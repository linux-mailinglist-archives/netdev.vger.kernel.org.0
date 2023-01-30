Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB67680DF6
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbjA3MoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235600AbjA3MoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:44:09 -0500
Received: from www530.your-server.de (www530.your-server.de [188.40.30.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049E3126D8;
        Mon, 30 Jan 2023 04:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=geanix.com;
        s=default2211; h=Content-Type:MIME-Version:Message-ID:In-Reply-To:Date:
        References:Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=jx2HZEKzOf3/azNeDJyrZb6Tm6tAKODgfyQiowftdrk=; b=ABJPOxDkseYqXvRu4BA54KvLPu
        SHBSdNxmsHhj+pg2h4hOIIjchWwcc6eoMm4HpaWGA9rH4zQihCGnHRkwAYbElAOSBazTvlhz+Q2l8
        r+l0uOJcip66qOLfYDTpjPumQuQ3omgMrb+hK4B4uKKXvxiM4vYnGzZnWQjdbhAjFrGvpY4hMCtqH
        RmfNqS2GFFilGJo3DkiD6/fxl3XOKLWoTem3wqmxkrHOUDvfxjL07FFPyZPP3G6/AfkNBYi4VEIzu
        lAnUAOhSXSs+qWsj/AWsOIQyEdPmjhH7GXDYwdx/rvGb+MIn9ejCyd+eZQOeUswBXQQG7hGK4YFET
        GU29TmFg==;
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www530.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <esben@geanix.com>)
        id 1pMTJQ-00085j-Sj; Mon, 30 Jan 2023 13:31:05 +0100
Received: from [80.62.117.235] (helo=localhost)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <esben@geanix.com>)
        id 1pMTJQ-000AtK-UG; Mon, 30 Jan 2023 13:31:05 +0100
From:   esben@geanix.com
To:     Jakub Kicinski <kuba@kernel.org>,
        Jonas Suhr Christensen <jsc@umbraculum.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: ll_temac: fix DMA resources leak
References: <20230126101607.88407-1-jsc@umbraculum.org>
        <20230127232034.1da0f4e1@kernel.org>
Date:   Mon, 30 Jan 2023 13:30:53 +0100
In-Reply-To: <20230127232034.1da0f4e1@kernel.org> (Jakub Kicinski's message of
        "Fri, 27 Jan 2023 23:20:34 -0800")
Message-ID: <87ilgo8arm.fsf@geanix.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Authenticated-Sender: esben@geanix.com
X-Virus-Scanned: Clear (ClamAV 0.103.7/26797/Mon Jan 30 09:24:58 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 26 Jan 2023 11:16:06 +0100 Jonas Suhr Christensen wrote:
>> Add missing conversion of address when unmapping dma region causing
>> unmapping to silently fail. At some point resulting in buffer
>> overrun eg. when releasing device.
>
> Could you add a Fixes tag pointing to the commit which introduced 
> the bug? It will help the stable teams backport the patch.

Fixes: fdd7454ecb29 ("net: ll_temac: Fix support for little-endian platforms")

> When reposting please put [PATCH net v2] as the prefix (noting 
> the target tree for the benefit of bots/CIs).
>
>> Signed-off-by: Jonas Suhr Christensen <jsc@umbraculum.org>
>> ---
>>  drivers/net/ethernet/xilinx/ll_temac_main.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
>> index 1066420d6a83..66c04027f230 100644
>> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
>> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
>> @@ -300,6 +300,7 @@ static void temac_dma_bd_release(struct net_device *ndev)
>>  {
>>  	struct temac_local *lp = netdev_priv(ndev);
>>  	int i;
>> +	struct cdmac_bd *bd;
>
> nit: we like variable declarations longest to shortest in networking
>  so before the int i; pls
>
>>  	/* Reset Local Link (DMA) */
>>  	lp->dma_out(lp, DMA_CONTROL_REG, DMA_CONTROL_RST);
