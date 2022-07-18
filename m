Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D221578E78
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 01:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiGRXuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 19:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbiGRXuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 19:50:17 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D23F33428;
        Mon, 18 Jul 2022 16:50:16 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id mf4so24211231ejc.3;
        Mon, 18 Jul 2022 16:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FUi0/o57ypNDejhrsGO7LDd0ItchnHcKM6bXLvOCA7w=;
        b=T1oPcDXC+TcU2V6vb1ujVQGUCcynn+8QL/eeYXcouwkXcfUdV9FvnhlD0kifxtZ5c8
         wtT0lOnwPcl5LW4Wjav1KfPDS3pf/IAGfDoJ2CUoJWXYqieOErvasJcKxV/ZGPlqLZQd
         qpNIlEkrMKMWZ1ez4PjJIcSiOi9oYQYX/1/rHpraI+o6dW9Jd5DDhpm7I5FB++kEp113
         B0gz3uS+JiOKQW+zVnzZTpBVRYmU0fJUlgPFQzY2tXak0OysIZISd/flp8IXMnlLgWQj
         jD5jUp0Sq8V5yz11nCPUkm+jZD3Ep24eMyyVq8u+DOq+Qa5FyMJvc7o/rn+Yr7WAxD0o
         avEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FUi0/o57ypNDejhrsGO7LDd0ItchnHcKM6bXLvOCA7w=;
        b=A3UNAF9OF+AqPu4QvMRqP/LOPIiwIRfzWCFzCSfeQ6FaQU9fOsvpF/R7KaZi9mj9rf
         VEvMsNhLskIbCHGeARwR5tTdwd6Y4VLsNqx9GtvpYVFFQbKGHIdefGaH36BNi7aD413e
         eLo+flpjR8fGrzWMtfn12zGLJBS8B1wbMrIvClwcgzN0/DIezKCuA2/Fm96QOO3bOMMT
         brq2V4W2JM041Agl+G//xfNbU2AJLtmVkEp/YaQY9MU6wXPWfwJ/5eY7xgF7NBNlUMpE
         U1mXwCMuKyw8EA6NldjYxbEB0TboMa/pavexTj+spUyEySgP/I0zylLVoDqal4V4vEf4
         0MXA==
X-Gm-Message-State: AJIora8EA96zLPm0rWK2MTt0RCzliH+un2qoUM+l0uzckU2TYSoktsKx
        gg0GAY5GeM99+zcUYy6jUJk=
X-Google-Smtp-Source: AGRyM1vDOJODtDNh2D+xzKc1sN8/JSTsELZd2Vwwb+KKR5PGjc8k352veUWezSMkGuCX93QWmCDuUQ==
X-Received: by 2002:a17:907:6e1d:b0:72f:20ad:e1b6 with SMTP id sd29-20020a1709076e1d00b0072f20ade1b6mr10042392ejc.545.1658188215005;
        Mon, 18 Jul 2022 16:50:15 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id p14-20020aa7cc8e000000b00435651c4a01sm9442505edt.56.2022.07.18.16.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 16:50:14 -0700 (PDT)
Date:   Tue, 19 Jul 2022 02:50:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next] net: dsa: microchip: fix the missing
 ksz8_r_mib_cnt
Message-ID: <20220718235012.gfn2dzirllcauiv3@skbuf>
References: <20220718061803.4939-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718061803.4939-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 11:48:03AM +0530, Arun Ramadoss wrote:
> During the refactoring for the ksz8_dev_ops from ksz8795.c to
> ksz_common.c, the ksz8_r_mib_cnt has been missed. So this patch adds the
> missing one.
> 
> Fixes: 6ec23aaaac43 ("net: dsa: microchip: move ksz_dev_ops to ksz_common.c")
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
