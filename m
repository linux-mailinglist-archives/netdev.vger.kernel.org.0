Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89675AB53A
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 12:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389423AbfIFKC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 06:02:26 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:54736 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388340AbfIFKC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 06:02:26 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 531ADA40070;
        Fri,  6 Sep 2019 10:02:24 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 6 Sep
 2019 03:02:19 -0700
Subject: Re: [PATCH net-next,v3 0/4] flow_offload: update mangle action
 representation
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jakub.kicinski@netronome.com>, <jiri@resnulli.us>,
        <saeedm@mellanox.com>, <vishal@chelsio.com>, <vladbu@mellanox.com>
References: <20190906000403.3701-1-pablo@netfilter.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <679ced4b-8bcd-5479-2773-7c75452c2a32@solarflare.com>
Date:   Fri, 6 Sep 2019 11:02:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190906000403.3701-1-pablo@netfilter.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24892.005
X-TM-AS-Result: No-8.343800-4.000000-10
X-TMASE-MatchedRID: UuaOI1zLN1geimh1YYHcKB4ejJMDGBzF69aS+7/zbj+qvcIF1TcLYHv6
        cG7t9uXq5KUs/3yM0ZkGfcxl2p20h9bWaZDKkrpabkgeRkAEcBQ1X1Ls767cppdtxl+wLu3UDDU
        NFdK2fLKRltJuNuhHN7Ri4KICxKHTuFhodb1Ei//wqDryy7bDIUloPruIq9jT5DjmdW0+qbH8Vn
        +hloEutRRF/q7q2TwKiMcoxFgHFXiZzIEe4t3y1ifyui9dY8akV447DNvw38a9riHHO5UXuDS1m
        54gUL0X+/AprGlolD3RCiTlD5prir17ZZvOyVXaYmbjxNY/eGA6En2bnefhoJm3TxN83Lo4RXHR
        k6xSaCMo9yfgEaU+fAp/E2lfYBlcv1l2Uvx6idpuHY1mnovlhPoA9r2LThYYKrauXd3MZDU2Fxd
        ax6Bwz/SgLcO7eXxqF49/s97VIFcNA698Ldnpv4doQhRQhfFhoaUNmmY5zMz+GjwwQjdUSu47ea
        ZWKP17xx8A7e6NfOpiJzfzr6gOcAbEQIfFpkwHBtlgFh29qnpKzBwu5JpklnOUuoTXM7r4Qwymt
        xuJ6y0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.343800-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24892.005
X-MDID: 1567764145-MVJEgGLdxR2n
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/09/2019 01:03, Pablo Neira Ayuso wrote:
> This patch updates the mangle action representation:
>
> Patch 1) Undo bitwise NOT operation on the mangle mask (coming from tc
>          pedit userspace).
>
> Patch 2) mangle value &= mask from the front-end side.
>
> Patch 3) adjust offset, length and coalesce consecutive pedit keys into
>          one single action.
>
> Patch 4) add support for payload mangling for netfilter.
>
> After this patchset:
>
> * Offset to payload does not need to be on the 32-bits boundaries anymore.
>   This patchset adds front-end code to adjust the offset and length coming
>   from the tc pedit representation, so drivers get an exact header field
>   offset and length.
>
> * This new front-end code coalesces consecutive pedit actions into one
>   single action, so drivers can mangle IPv6 and ethernet address fields
>   in one go, instead once for each 32-bit word.
>
> On the driver side, diffstat -t shows that drivers code to deal with
> payload mangling gets simplified:
>
>         INSERTED,DELETED,MODIFIED,FILENAME
>         46,116,0,drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c (-70 LOC)
>         12,28,0,drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h (-16 LOC)
> 	26,54,0,drivers/net/ethernet/mellanox/mlx5/core/en_tc.c (-27 LOC)
>         89,111,0,drivers/net/ethernet/netronome/nfp/flower/action.c (-17 LOC)
>
> While, on the front-end side the balance is the following:
>
>         123,22,0,net/sched/cls_api.c (+101 LOC)
>
> Changes since v2:
>
> * Fix is_action_keys_supported() breakage in mlx5 reported by Vlad Buslov.
Still NAK for the same reasons as three versions ago (when it was called
 "netfilter: payload mangling offload support"), you've never managed to
 explain why this extra API complexity is useful.  (Reducing LOC does not
 mean you've reduced complexity.)

As Jakub said, 'We suffered through enough haphazard "updates"'.  Please
 can you fix the problems your previous API changes caused (I still haven't
 had an answer about the flow block changes since sending you my driver code
 two weeks ago) before trying to ram new ones through.

-Ed
