Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2537D59E5DD
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 17:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242665AbiHWPRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 11:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242644AbiHWPR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 11:17:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AA615C906
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661251361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rL8SJbgibVkoZ2njYSulQFsOA3EsniOZm6ohlbk2wZI=;
        b=Hdl8Lc2+E4yfqHZ79V7jD8xVozO4lf4Sc3kRhmkzOLaK2c5Mv0sCfSdRpxS7xYyl+ol6XO
        Z6r9i3m0BHDLZ6PeddnTmPU5JVmL6CF6NoC1M5HoDycLRboSk0zTPVzpvr2lgNXtFFzv4B
        HhoitH3aldrGxMnSObgxpAS5vNDDo/E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-518-9VZF3XluNkuXZ_9IS2LMfQ-1; Tue, 23 Aug 2022 06:42:39 -0400
X-MC-Unique: 9VZF3XluNkuXZ_9IS2LMfQ-1
Received: by mail-wm1-f70.google.com with SMTP id b4-20020a05600c4e0400b003a5a96f1756so10108807wmq.0
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:42:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=rL8SJbgibVkoZ2njYSulQFsOA3EsniOZm6ohlbk2wZI=;
        b=XPbGjqIiWOkQSGUEwDlqVOfboHfS10J/THyUcgIml+Ye615yFvZJY4e1gqHRVFvdMV
         HHYsT1F5HmXxMp7PkgdqTOgcoiQUnm4UXfDaSFcTRR0onsFGbIUXFpdQIFZFhpRIytqS
         F1z2OjPp3B6x6GYvjIGI8prNQIrmby/jK8nquoFPK53BAKYk2uGOyFWfWM+wsxG7ZRwU
         7MMYkz0IcWM5PPl7KWQ0zgKrq55icEDZr69wdoKDsfNOM28ivChXrpEfeUCn1TWgAW54
         aNH6tX92QgEJB8ud8XcBPvT2kOWLOQO+tDUs+v+Cfq11DPcmjJgWMZ85mlU9eIRvhCtX
         OrUw==
X-Gm-Message-State: ACgBeo19rhadSaHg6yPCD3tYBDLq8cYOeFoi5ru+KenVL54B7r8QRnhF
        IF5XN9Kg3ARTDzVIsQpPZ+YaeEUvLpJebPlevjW/Rb13WIINKuspBhK+7sN0FF7XxPw88nYp2dX
        iR9bU02wvTvEpnGDw
X-Received: by 2002:a05:6000:178f:b0:221:7dcb:7cbf with SMTP id e15-20020a056000178f00b002217dcb7cbfmr13267574wrg.58.1661251357626;
        Tue, 23 Aug 2022 03:42:37 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6HEWu5qW/d+rzi2SfObMW+7Cw8xxikVX1LMuZMnMjuXybMaFefYdUhprqmbI+ylFucll3hJA==
X-Received: by 2002:a05:6000:178f:b0:221:7dcb:7cbf with SMTP id e15-20020a056000178f00b002217dcb7cbfmr13267545wrg.58.1661251357353;
        Tue, 23 Aug 2022 03:42:37 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-176.dyn.eolo.it. [146.241.97.176])
        by smtp.gmail.com with ESMTPSA id c7-20020a05600c0a4700b003a342933727sm9273171wmq.3.2022.08.23.03.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 03:42:36 -0700 (PDT)
Message-ID: <abce7e128957b3e86a6d73a7b383b6404ba2db65.camel@redhat.com>
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: fix hw hash
 reporting for MTK_NETSYS_V2
From:   Paolo Abeni <pabeni@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Date:   Tue, 23 Aug 2022 12:42:35 +0200
In-Reply-To: <890fc9b747e7729fb6b082a1f7fd309a58768cca.1661012748.git.lorenzo@kernel.org>
References: <890fc9b747e7729fb6b082a1f7fd309a58768cca.1661012748.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, 2022-08-20 at 18:27 +0200, Lorenzo Bianconi wrote:
> Properly report hw rx hash for mt7986 chipset accroding to the new dma
> descriptor layout.
> 
> Fixes: 197c9e9b17b11 ("net: ethernet: mtk_eth_soc: introduce support for mt7986 chipset")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

This looks like a simple fix and the commit pointed by the 'fixes' tag
is already on -net. Would you mind to repost this targeting the
appropriate tree? Or there is any special reason to target net-next
instead?

Thanks!

Paolo

