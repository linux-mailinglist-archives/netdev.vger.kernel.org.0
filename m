Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5093B5A0AD
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfF1QTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:19:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:20473 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbfF1QTO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 12:19:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 09:19:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,428,1557212400"; 
   d="scan'208";a="167801019"
Received: from klaatz-mobl1.ger.corp.intel.com (HELO [10.252.3.92]) ([10.252.3.92])
  by orsmga006.jf.intel.com with ESMTP; 28 Jun 2019 09:19:10 -0700
Subject: Re: [PATCH 00/11] XDP unaligned chunk placement support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com
References: <20190620083924.1996-1-kevin.laatz@intel.com>
 <FA8389B9-F89C-4BFF-95EE-56F702BBCC6D@gmail.com>
 <ef7e9469-e7be-647b-8bb1-da29bc01fa2e@intel.com>
 <20190627142534.4f4b8995@cakuba.netronome.com>
From:   "Laatz, Kevin" <kevin.laatz@intel.com>
Message-ID: <f0ca817a-02b4-df22-d01b-7bc07171a4dc@intel.com>
Date:   Fri, 28 Jun 2019 17:19:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190627142534.4f4b8995@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/06/2019 22:25, Jakub Kicinski wrote:
> On Thu, 27 Jun 2019 12:14:50 +0100, Laatz, Kevin wrote:
>> On the application side (xdpsock), we don't have to worry about the user
>> defined headroom, since it is 0, so we only need to account for the
>> XDP_PACKET_HEADROOM when computing the original address (in the default
>> scenario).
> That assumes specific layout for the data inside the buffer.  Some NICs
> will prepend information like timestamp to the packet, meaning the
> packet would start at offset XDP_PACKET_HEADROOM + metadata len..

Yes, if NICs prepend extra data to the packet that would be a problem for
using this feature in isolation. However, if we also add in support for 
in-order
RX and TX rings, that would no longer be an issue. However, even for NICs
which do prepend data, this patchset should not break anything that is 
currently
working.

>
> I think that's very limiting.  What is the challenge in providing
> aligned addresses, exactly?
The challenges are two-fold:
1) it prevents using arbitrary buffer sizes, which will be an issue 
supporting e.g. jumbo frames in future.
2) higher level user-space frameworks which may want to use AF_XDP, such 
as DPDK, do not currently support having buffers with 'fixed' alignment.
     The reason that DPDK uses arbitrary placement is that:
         - it would stop things working on certain NICs which need the 
actual writable space specified in units of 1k - therefore we need 2k + 
metadata space.
         - we place padding between buffers to avoid constantly hitting 
the same memory channels when accessing memory.
         - it allows the application to choose the actual buffer size it 
wants to use.
     We make use of the above to allow us to speed up processing 
significantly and also reduce the packet buffer memory size.

     Not having arbitrary buffer alignment also means an AF_XDP driver 
for DPDK cannot be a drop-in replacement for existing drivers in those 
frameworks. Even with a new capability to allow an arbitrary buffer 
alignment, existing apps will need to be modified to use that new 
capability.

