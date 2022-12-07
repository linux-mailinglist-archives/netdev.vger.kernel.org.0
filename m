Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188F86457BF
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiLGK0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiLGK0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:26:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D601743E
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670408665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fmvXrECUWDpk6CjKs72LNRaUpi6UQ7pNxjEBABaDBAw=;
        b=WwxKI9exJfAuc2M9gUYhOMW8nShwmvYOI2UsT1xVLv950SIaCRwZ9OIxJ+zsSCBHqs6368
        MKTb6iJFGQtjr6LfbpU+qbR3wAO2qCThGYBkqeNmyVU3Dkc7YtITfyVABs80JVcxdwRGsi
        PjeXMRnEXoYvtU0cMdgiW+lqtOGL/Ms=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-454-PEqWVDgZMLWDON4owCkV-Q-1; Wed, 07 Dec 2022 05:24:24 -0500
X-MC-Unique: PEqWVDgZMLWDON4owCkV-Q-1
Received: by mail-wr1-f72.google.com with SMTP id i25-20020adfaad9000000b002426945fa63so2226541wrc.6
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 02:24:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fmvXrECUWDpk6CjKs72LNRaUpi6UQ7pNxjEBABaDBAw=;
        b=8HTruJcZx5KhGLCgRTFsicmXRL9CV+/QJ0Kd2RdwYj5D34BVXfPLVt1zaUHlN3fk8J
         wQVI87NVYrsHJKD1Rka44JId1kizSSXXJXVIQ0WS61lH3pjwHx1n7u24MRsFct5yenhU
         k5r+NgIkGu2QuTGd3/5ePhTPWuXUkJ0mXc1vfxrYZpKZ8jTliawWSk3QhN0RLVC3iK25
         IcDaOTMfhkwrzLL1zGhKtPQciEV+71rtmYntLBLEa3WOgyg7b+f5Y6A5fn5FXqfsiTNn
         HT77s1uc9p5uTOOdH5gIByaFjzAjJceRtme0LCB0u/gFYGjoqyIqTCISPaGpy94ZrMRv
         Ad8w==
X-Gm-Message-State: ANoB5pmkg0WitrwfOWNwM8+D33TgBPPt7vYmJDgO1Lb/UpKEiQTmbQWb
        /5IAEORvm8mxJDBqxFjqLH3LF0+GmpEx1vTBGo7vADUZWNP9K+JMaGlf4fCQB280wMKoVCx4/Sg
        eRSK5S4MiFyzLGmkA
X-Received: by 2002:a05:6000:81a:b0:242:6a15:e257 with SMTP id bt26-20020a056000081a00b002426a15e257mr6351933wrb.624.1670408663412;
        Wed, 07 Dec 2022 02:24:23 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7yuMyB4HeLgRx4qKqSu2DdpE8gVi8YNKTm3Lh1BRToR9uSlG3n+rU2LpoAoGJwem9ysaJsow==
X-Received: by 2002:a05:6000:81a:b0:242:6a15:e257 with SMTP id bt26-20020a056000081a00b002426a15e257mr6351917wrb.624.1670408663189;
        Wed, 07 Dec 2022 02:24:23 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-106-100.dyn.eolo.it. [146.241.106.100])
        by smtp.gmail.com with ESMTPSA id z8-20020adfdf88000000b002258235bda3sm19041944wrl.61.2022.12.07.02.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 02:24:22 -0800 (PST)
Message-ID: <db3d16ff19ee4558bf96e585e56661eb626163df.camel@redhat.com>
Subject: Re: [PATCH net-next 2/6] tsnep: Add XDP TX support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
Date:   Wed, 07 Dec 2022 11:24:21 +0100
In-Reply-To: <20221203215416.13465-3-gerhard@engleder-embedded.com>
References: <20221203215416.13465-1-gerhard@engleder-embedded.com>
         <20221203215416.13465-3-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-12-03 at 22:54 +0100, Gerhard Engleder wrote:
[...]
> +/* This function requires __netif_tx_lock is held by the caller. */
> +static int tsnep_xdp_xmit_frame_ring(struct xdp_frame *xdpf,
> +				     struct tsnep_tx *tx, bool dma_map)
> +{
> +	struct skb_shared_info *shinfo = xdp_get_shared_info_from_frame(xdpf);
> +	unsigned long flags;
> +	int count = 1;
> +	struct tsnep_tx_entry *entry;
> +	int length;
> +	int i;
> +	int retval;
> +
> +	if (unlikely(xdp_frame_has_frags(xdpf)))
> +		count += shinfo->nr_frags;
> +
> +	spin_lock_irqsave(&tx->lock, flags);

Not strictily related to this patch, but why are you using the _irqsafe
variant? it looks like all the locak users are either in process or BH
context.

Thanks!

Paolo

