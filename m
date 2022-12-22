Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC90A653E79
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 11:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbiLVKpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 05:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbiLVKpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 05:45:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D87B83
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 02:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671705855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gi5urjN2N7QuS8JEXiq0+o2rzUnJbYSXkxKQ9B/QdeU=;
        b=SnERvi0TcB6vPW5PuckKX3qsDzGM9AdoH0VlAPTJmcvw54+C7LZ+MnTxeCGUAn1XwEznjO
        lMw0k14mKpCylj8/w0BEBELxpefVp+GNP3AsAE4ymHpj7eXNl9nzTk5rDuIQFW2cH/WiZc
        S6OQCB8p8D9M+udCUl8HjjCzVlDnOYA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-SUTcLjaKM5KZt6AZez-pAA-1; Thu, 22 Dec 2022 05:44:13 -0500
X-MC-Unique: SUTcLjaKM5KZt6AZez-pAA-1
Received: by mail-wm1-f72.google.com with SMTP id x10-20020a05600c420a00b003cfa33f2e7cso737792wmh.2
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 02:44:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gi5urjN2N7QuS8JEXiq0+o2rzUnJbYSXkxKQ9B/QdeU=;
        b=sPirqERBx1mZYUazPw2PFCfACiAgvss0Bipd2LS43L0btXnwkuFGP94ogZb/DmxATQ
         QH5rajaMNQ4T9soFHFLhOXqfV39cKc7VWFc9smlmTh5PjIWKwdpS3mJJhbWCGqkC9tKc
         oKeDBGGMpI+voUStXMuowk6ADqFwO/3QKF5bnjzGVOgas0pfKqopbi0ZYCDasb9E5wD+
         tPYCG3gxTQWB8Bztq9bF7fQnGQkqvFOVkRup0rw8drQH7d5pVJ99ZKXxfEEYpFwoTQjR
         ag6JlzwBnZZccK9ts1Dz9rIo7isrlxa4bJ9tklUm6UsiXIDEEV1AhgNLm+OeyUR+LgkI
         jt0Q==
X-Gm-Message-State: AFqh2kqCvtj2Xm7G/UhnH9UQsQrpHpv6PxBjpEx6VOEFiyinDquGmCFO
        TFR7bc+eQbiQsMyOzrga1zEjWqBM01WDAASVoTNFvHJVj7mtt22SwVO6Qs2691G+QPpz7OPMh3m
        6SYCmBB72SBUIsBpS
X-Received: by 2002:a5d:43c7:0:b0:26b:c52e:f7c7 with SMTP id v7-20020a5d43c7000000b0026bc52ef7c7mr4018751wrr.29.1671705852492;
        Thu, 22 Dec 2022 02:44:12 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvni/JVJYdZYhjeyU1Sy9xUOEsBi09aiftzU746b9vFIpzA/VFtRgh8+4XjsBHPtjl9arvOPg==
X-Received: by 2002:a5d:43c7:0:b0:26b:c52e:f7c7 with SMTP id v7-20020a5d43c7000000b0026bc52ef7c7mr4018734wrr.29.1671705852266;
        Thu, 22 Dec 2022 02:44:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id h15-20020adfaa8f000000b002421888a011sm184094wrc.69.2022.12.22.02.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 02:44:11 -0800 (PST)
Message-ID: <8a0a90511222d3161bfe2984f6b14f82206b8930.camel@redhat.com>
Subject: Re: [PATCH 0/3] net/ncsi: Add NC-SI 1.2 Get MC MAC Address command
From:   Paolo Abeni <pabeni@redhat.com>
To:     Peter Delevoryas <peter@pjd.dev>
Cc:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, joel@jms.id.au, gwshan@linux.vnet.ibm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 22 Dec 2022 11:44:10 +0100
In-Reply-To: <20221221052246.519674-1-peter@pjd.dev>
References: <20221221052246.519674-1-peter@pjd.dev>
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

On Tue, 2022-12-20 at 21:22 -0800, Peter Delevoryas wrote:
> NC-SI 1.2 isn't officially released yet, but the DMTF takes way too long
> to finalize stuff, and there's hardware out there that actually supports
> this command (Just the Broadcom 200G NIC afaik).
> 
> The work in progress spec document is here:
> 
> https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.2WIP90_0.pdf
> 
> The command code is 0x58, the command has no data, and the response
> returns a variable-length array of MAC addresses for the BMC.
> 
> I've tested this out using QEMU emulation (I added the Mellanox OEM Get
> MAC Address command to libslirp a while ago [1], although the QEMU code
> to use it is still not in upstream QEMU [2] [3]. I worked on some more
> emulation code for this as well), and on the new Broadcom 200G NIC.
> 
> The Nvidia ConnectX-7 NIC doesn't support NC-SI 1.2 yet afaik. Neither
> do older versions in newer firmware, they all just report NC-SI 1.1.
> 
> Let me know what I can do to change this patch to be more suitable for
> upstreaming, I'm happy to work on it more!

This series is targeting the net-next tree, you should include such tag
into the patch subjected.

We have already submitted the networking pull request to Linus
for v6.2 and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after Jan 2nd.

RFC patches sent for review only are obviously welcome at any time.

Thanks,

Paolo

