Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF665BED4
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 16:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfGAO6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 10:58:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:18083 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbfGAO6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 10:58:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 07:58:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,439,1557212400"; 
   d="scan'208";a="186506946"
Received: from klaatz-mobl1.ger.corp.intel.com (HELO [10.237.221.70]) ([10.237.221.70])
  by fmsmga004.fm.intel.com with ESMTP; 01 Jul 2019 07:58:06 -0700
Subject: Re: [PATCH 00/11] XDP unaligned chunk placement support
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com
References: <20190620083924.1996-1-kevin.laatz@intel.com>
 <FA8389B9-F89C-4BFF-95EE-56F702BBCC6D@gmail.com>
 <ef7e9469-e7be-647b-8bb1-da29bc01fa2e@intel.com>
 <20190627142534.4f4b8995@cakuba.netronome.com>
 <f0ca817a-02b4-df22-d01b-7bc07171a4dc@intel.com>
 <BAE24CBF-416D-4665-B2C9-CE1F5EAE28FF@gmail.com>
From:   "Laatz, Kevin" <kevin.laatz@intel.com>
Message-ID: <c6c48475-c4c8-599f-8217-4bc0f4d26a90@intel.com>
Date:   Mon, 1 Jul 2019 15:58:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <BAE24CBF-416D-4665-B2C9-CE1F5EAE28FF@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/06/2019 21:29, Jonathan Lemon wrote:
> On 28 Jun 2019, at 9:19, Laatz, Kevin wrote:
>> On 27/06/2019 22:25, Jakub Kicinski wrote:
>>> I think that's very limiting.  What is the challenge in providing
>>> aligned addresses, exactly?
>> The challenges are two-fold:
>> 1) it prevents using arbitrary buffer sizes, which will be an issue 
>> supporting e.g. jumbo frames in future.
>> 2) higher level user-space frameworks which may want to use AF_XDP, 
>> such as DPDK, do not currently support having buffers with 'fixed' 
>> alignment.
>>     The reason that DPDK uses arbitrary placement is that:
>>         - it would stop things working on certain NICs which need the 
>> actual writable space specified in units of 1k - therefore we need 2k 
>> + metadata space.
>>         - we place padding between buffers to avoid constantly 
>> hitting the same memory channels when accessing memory.
>>         - it allows the application to choose the actual buffer size 
>> it wants to use.
>>     We make use of the above to allow us to speed up processing 
>> significantly and also reduce the packet buffer memory size.
>>
>>     Not having arbitrary buffer alignment also means an AF_XDP driver 
>> for DPDK cannot be a drop-in replacement for existing drivers in 
>> those frameworks. Even with a new capability to allow an arbitrary 
>> buffer alignment, existing apps will need to be modified to use that 
>> new capability.
>
> Since all buffers in the umem are the same chunk size, the original 
> buffer
> address can be recalculated with some multiply/shift math. However, 
> this is
> more expensive than just a mask operation.


Yes, we can do this.

Another option we have is to add a socket option for querying the 
metadata length from the driver (assuming it doesn't vary per packet). 
We can use that information to get back the original address using 
subtraction.

Alternatively, we can change the Rx descriptor format to include the 
metadata length. We could do this in a couple of ways, for example, 
rather than returning the address at the start of the packet, instead 
return the buffer address that was passed in, and adding another 16-bit 
field to specify the start of the packet offset with that buffer. Id 
using 16-bits of descriptor space is not desirable, an alternative could 
be to limit umem sizes to e.g. 2^48 bits (256 terabytes should be 
enough, right :-) ) and use the remaining 16 bits of the address as a 
packet offset. Other variations on these approaches are obviously 
possible too.

