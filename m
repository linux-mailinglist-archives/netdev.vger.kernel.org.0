Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81378D9580
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 17:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404804AbfJPP1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 11:27:16 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:44664 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403784AbfJPP1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 11:27:16 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 80D98340084;
        Wed, 16 Oct 2019 15:27:14 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 16 Oct
 2019 08:26:52 -0700
Subject: Stable request (was Re: [PATCH net-next] net: ipv6: fix listify
 ip6_rcv_finish in case of forwarding)
From:   Edward Cree <ecree@solarflare.com>
To:     David Miller <davem@davemloft.net>
CC:     <lucien.xin@gmail.com>, <netdev@vger.kernel.org>,
        <linux-sctp@vger.kernel.org>, <marcelo.leitner@gmail.com>,
        <nhorman@tuxdriver.com>, <brouer@redhat.com>, <dvyukov@google.com>,
        <syzkaller-bugs@googlegroups.com>
References: <e355527b374f6ce70fcc286457f87592cd8f3dcc.1566559983.git.lucien.xin@gmail.com>
 <20190823.144250.2063544404229146484.davem@davemloft.net>
 <3bda6dee-7b8b-1f50-b4ea-47857ca97279@solarflare.com>
Message-ID: <fa2e9f70-05bd-bcac-e502-8bdb375163ce@solarflare.com>
Date:   Wed, 16 Oct 2019 16:26:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <3bda6dee-7b8b-1f50-b4ea-47857ca97279@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24980.005
X-TM-AS-Result: No-12.113900-4.000000-10
X-TMASE-MatchedRID: Kt9m641lzn0+D3J+ThgLRgGdJZ3Knh6h6VTG9cZxEjKtyIlQ9jhSMX91
        voLn76c17xqRZoZCHagIl1lIQSnNKB1YpEPWJiyzGi6hW8XaLRkl2afHiIQqIyS30GKAkBxWrZL
        AiMblSRHes2t0sdNfliSUrOJpt1adT8T8t9BFA6/IFa+p8pQ57i+7N1Fn6XdzxuolijDY9YBz1l
        g2O4UklZHoSZDvMF/eCbBJq0mAZ27/BzgGZKzw3fRUId35VCIexXRDKEyu2zG5TOQXOCqWtTFIE
        upeTTSNLRYHV4sGJagBwt5sHlizCqObxoz1kVMAngIgpj8eDcBZDL1gLmoa/PoA9r2LThYYKrau
        Xd3MZDXVWUcRd+ux6hKplSJdZiaVE8MoXMCtu4ORAvI612PdpMD5hSN4BFxz
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.113900-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24980.005
X-MDID: 1571239635-rX58VjNamCZr
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/10/2019 16:17, Edward Cree wrote:
> On 23/08/2019 22:42, David Miller wrote:
>> From: Xin Long <lucien.xin@gmail.com>
>> Date: Fri, 23 Aug 2019 19:33:03 +0800
>>
>>> We need a similar fix for ipv6 as Commit 0761680d5215 ("net: ipv4: fix
>>> listify ip_rcv_finish in case of forwarding") does for ipv4.
>>>
>>> This issue can be reprocuded by syzbot since Commit 323ebb61e32b ("net:
>>> use listified RX for handling GRO_NORMAL skbs") on net-next. The call
>>> trace was:
>>  ...
>>> Fixes: d8269e2cbf90 ("net: ipv6: listify ipv6_rcv() and ip6_rcv_finish()")
>>> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
>>> Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
>>> Reported-by: syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com
>>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> Applied, thanks.
> Just noticed that this only went to net-next (and 5.4-rc1), when actually
>  it's needed on all kernels back to 4.19 (per the first Fixes: tag).  The
>  second Fixes: reference, 323ebb61e32b, merely enables syzbot to hit it on
>  whatever hardware it has, but the bug was already there, and hittable on
>  sfc NICs.
> David, can this go to stable please?
Hi, did this get missed or was my request improper in some way?
Our testing has been hitting this issue on distro kernels (Fedora, Debian,
 Ubuntu), we'd like the fix to get everywhere it's needed and AIUI -stable
 is the proper route for that.
For reference, the fix was committed as c7a42eb49212.

-Ed
