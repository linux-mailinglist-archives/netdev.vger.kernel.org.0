Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6EF4E61A0
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 11:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349454AbiCXKVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 06:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346218AbiCXKVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 06:21:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C73D9222A0
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 03:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648117184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1gJjOobX3SRbiNCeHg0LuvpgzFcZz0S0lDQOV3qNy6Y=;
        b=CUmOSWDZ6r06+1rTk3dphGYydPPOY2SAuve5YzAfe6FrxqFErlRIyg0fk9FmPA+iiHJynL
        Z1sqVNY99SZUul+oY6UjIwGabVmxSnecfGkY5WMNQBgSe3N0lpBK5OMH5eYOObrIwU096u
        OTPzPBDIvvs/rVxopelHHT3yZ0CliVE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-e6ykFWNXOvCue-px-jBVFQ-1; Thu, 24 Mar 2022 06:19:43 -0400
X-MC-Unique: e6ykFWNXOvCue-px-jBVFQ-1
Received: by mail-wm1-f71.google.com with SMTP id 2-20020a1c0202000000b0038c71e8c49cso3868260wmc.1
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 03:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1gJjOobX3SRbiNCeHg0LuvpgzFcZz0S0lDQOV3qNy6Y=;
        b=cBSL3eQ3T5EQEM6JPm9xgYnKLt0xw2zfYVxhBqyubIkpTiVLFK44wufgWLV74YHy3j
         5ANnj+H0azFcGAKpTkYyKFRIsSHj7Z/snWSYeSV1PDb+pxhwUOKjgDkKeluPwmVX1yEi
         4xD3st1+6aHFazenth2JKNhz4y6Pzb79SF3gFvy7nRftX0GIly1eJIaaJ4KQBp/wUjit
         3Kg0AACqkWWKX7xmK1G0SJzVGOY5dVIaECDY0Lr5MYn6MdvS6mIp2ghTOLrV++7m/5RO
         wN5cgMX2DYLsiXzTkZrLFt0Zw8Y6ruVd1wQ48BogNC14BMMfNCdURiNdEvtpBjDdjtWL
         1rFg==
X-Gm-Message-State: AOAM531eiSUWSPh6zJqKfxGRdZCNkGcfQHmBUzqJVB184qiG4C6Tbs+4
        WnGNa2vrPD8PTmP1AZKAXgEgfQzNvxHbYs7KTt8c4yVlpAqqDo0SvlbPPViiPM81u7driKY5/8M
        FhuzLlp5PUy8JQuCG
X-Received: by 2002:a5d:6149:0:b0:204:4a17:bf2 with SMTP id y9-20020a5d6149000000b002044a170bf2mr3964791wrt.379.1648117182453;
        Thu, 24 Mar 2022 03:19:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWi/GlpLsx0oVqY3VxN1g+/kbaTkjtYq6DyeMLoEDu/imv7vhTr7Ns2WO/c/diJleL3cUk0Q==
X-Received: by 2002:a5d:6149:0:b0:204:4a17:bf2 with SMTP id y9-20020a5d6149000000b002044a170bf2mr3964767wrt.379.1648117182208;
        Thu, 24 Mar 2022 03:19:42 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id f7-20020a1cc907000000b0038c756fe683sm5649938wmb.43.2022.03.24.03.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 03:19:41 -0700 (PDT)
Message-ID: <4f031821d48501f06ca1e7c6a91101d7c341f1d7.camel@redhat.com>
Subject: Re: [PATCH net-next] dt-bindings: net: snps,dwmac: modify available
 values of PBL
From:   Paolo Abeni <pabeni@redhat.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, srv_heupstream@mediatek.com,
        macpaul.lin@mediatek.com, Biao Huang <biao.huang@mediatek.com>,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 24 Mar 2022 11:19:40 +0100
In-Reply-To: <20220324012112.7016-2-biao.huang@mediatek.com>
References: <20220324012112.7016-1-biao.huang@mediatek.com>
         <20220324012112.7016-2-biao.huang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2022-03-24 at 09:21 +0800, Biao Huang wrote:
> PBL can be any of the following values: 1, 2, 4, 8, 16 or 32
> according to the datasheet, so modify available values of PBL in
> snps,dwmac.yaml.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>

@Rob: my understanding is that this patch will go through your tree,
despite being marked as net-next. Please correct me if I'm wrong,
thanks!

Paolo

