Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6224758134
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 13:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfF0LOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 07:14:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:43301 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfF0LOy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 07:14:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 04:14:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,423,1557212400"; 
   d="scan'208";a="162604553"
Received: from klaatz-mobl1.ger.corp.intel.com (HELO [10.237.221.70]) ([10.237.221.70])
  by fmsmga008.fm.intel.com with ESMTP; 27 Jun 2019 04:14:51 -0700
Subject: Re: [PATCH 00/11] XDP unaligned chunk placement support
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        bpf@vger.kernel.com, intel-wired-lan@lists.osuosl.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com
References: <20190620083924.1996-1-kevin.laatz@intel.com>
 <FA8389B9-F89C-4BFF-95EE-56F702BBCC6D@gmail.com>
From:   "Laatz, Kevin" <kevin.laatz@intel.com>
Message-ID: <ef7e9469-e7be-647b-8bb1-da29bc01fa2e@intel.com>
Date:   Thu, 27 Jun 2019 12:14:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <FA8389B9-F89C-4BFF-95EE-56F702BBCC6D@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25/06/2019 19:44, Jonathan Lemon wrote:
> On 20 Jun 2019, at 1:39, Kevin Laatz wrote:
>
>> This patchset adds the ability to use unaligned chunks in the XDP umem.
>>
>> Currently, all chunk addresses passed to the umem are masked to be chunk
>> size aligned (default is 2k, max is PAGE_SIZE). This limits where we can
>> place chunks within the umem as well as limiting the packet sizes 
>> that are
>> supported.
>>
>> The changes in this patchset removes these restrictions, allowing XDP 
>> to be
>> more flexible in where it can place a chunk within a umem. By 
>> relaxing where
>> the chunks can be placed, it allows us to use an arbitrary buffer 
>> size and
>> place that wherever we have a free address in the umem. These changes 
>> add the
>> ability to support jumboframes and make it easy to integrate with other
>> existing frameworks that have their own memory management systems, 
>> such as
>> DPDK.
>
> I'm a little unclear on how this should work, and have a few issues here:
>
>  1) There isn't any support for the user defined umem->headroom
>

For the unaligned chunks case, it does not make sense to to support a 
user defined headroom since the user can point directly to where they 
want the data to start via the buffer address. Therefore, for unaligned 
chunks, the user defined headroom should always be 0 (aka the user did 
not define a headroom and the default value of 0 is used). Any other 
value will be caught and we return an invalid argument error.


>  2) When queuing RX buffers, the handle (aka umem offset) is used, which
>     points to the start of the buffer area.  When the buffer appears in
>     the completion queue, handle points to the start of the received 
> data,
>     which might be different from the buffer start address.
>
>     Normally, this RX address is just put back in the fill queue, and the
>     mask is used to find the buffer start address again.  This no longer
>     works, so my question is, how is the buffer start address recomputed
>     from the actual data payload address?
>
>     Same with TX - if the TX payload isn't aligned in with the start of
>     the buffer, what happens?

On the application side (xdpsock), we don't have to worry about the user 
defined headroom, since it is 0, so we only need to account for the 
XDP_PACKET_HEADROOM when computing the original address (in the default 
scenario). This was missing from the v1, will add this in the v2, to 
have xdpsock use the default value from libbpf! If the user is using 
another BPF program that uses a different offset, then the computation 
will need to be adjusted for that accordingly. In v2 we'll add support 
for this via command-line parameter.

However, we are also working on an "in-order" patchset, hopefully to be 
published soon, to guarantee the buffers returned to the application are 
in the same order as those provided to the kernel. Longer term, this is 
the best solution here as it allows the application to track itself, via 
a "shadow ring" or otherwise, the buffers sent to the kernel and any 
metadata associated with them, such as the start of buffer address.

>
>  3) This appears limited to crossing a single page boundary, but there
>     is no constraint check on chunk_size.

There is an existing check for chunk_size during xdp_umem_reg (in 
xdp_umem.c) The check makes sure that chunk size is at least 
XDP_UMEM_MIN_CHUNK_SIZE and at most PAGE_SIZE. Since the max is page 
size, we only need to check the immediate next page for contiguity.
While this patchset allows a max of 4k sized buffers, it is still an 
improvement from the current state. Future enhancements could look into 
extending the 4k limit but for now it is a good first step towards 
supporting hugepages efficiently.

Best regards,
Kevin
