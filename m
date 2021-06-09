Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBE93A1B74
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 19:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhFIRG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 13:06:29 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:56518 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbhFIRG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 13:06:28 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 159H4Trl121716;
        Wed, 9 Jun 2021 12:04:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1623258269;
        bh=s/MwSlFHOLVCNUFd2xamkY0eTx7OKtxYJQXO4fJst6s=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=OAHDIsut/vOI9fl/jfVx7yb1Vyuq8QUk9Bu7XLLJP69Raql6SORFJ5R7KF1kj8ceW
         02MPO3dBVWBowpp/xA/Gl3TvfLUyf/0Oxw4lbhdIXXHZPpzaDvCYOGYJR3oigKAo4m
         wImbodcbKt2LCa6hixqsdDwPXFLsgDe0tHPS/oLo=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 159H4TWU043300
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 9 Jun 2021 12:04:29 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 9 Jun
 2021 12:04:28 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 9 Jun 2021 12:04:28 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 159H4QON031321;
        Wed, 9 Jun 2021 12:04:27 -0500
Subject: Re: [PATCH bpf-next 17/17] net: ti: remove rcu_read_lock() around XDP
 program invocation
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        <linux-omap@vger.kernel.org>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-18-toke@redhat.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <667a26bb-f414-0694-f0c6-299451fd8f2e@ti.com>
Date:   Wed, 9 Jun 2021 20:04:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210609103326.278782-18-toke@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/06/2021 13:33, Toke Høiland-Jørgensen wrote:
> The cpsw driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
> program invocations. However, the actual lifetime of the objects referred
> by the XDP program invocation is longer, all the way through to the call to
> xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
> turns out to be harmless because it all happens in a single NAPI poll
> cycle (and thus under local_bh_disable()), but it makes the rcu_read_lock()
> misleading.
> 
> Rather than extend the scope of the rcu_read_lock(), just get rid of it
> entirely. With the addition of RCU annotations to the XDP_REDIRECT map
> types that take bh execution into account, lockdep even understands this to
> be safe, so there's really no reason to keep it around.
> 
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Cc: linux-omap@vger.kernel.org
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>   drivers/net/ethernet/ti/cpsw_priv.c | 10 ++--------
>   1 file changed, 2 insertions(+), 8 deletions(-)

Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
