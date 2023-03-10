Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4556B4BAE
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 16:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjCJPxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 10:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbjCJPwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 10:52:30 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D6F1ACD8;
        Fri, 10 Mar 2023 07:45:15 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id k37so3693724wms.0;
        Fri, 10 Mar 2023 07:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678463114;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dKsqBboH0bFfsTwY9easxEwnBQtTjr8MI+NIbG15Q4E=;
        b=FSbozOfKvQ0yLANaCquRNtdUOoWRUGksqLCLGjv8mN7NJ8iZxeKGgP4C3c7soZoQAf
         cQy+UnsnsbSwZ79fFXaiaBfwu1xKf88ox+vcir/9o4aGlIlkw3hqPmBp0aJ4s8K6Z9wB
         afZoaQqd/c88l63ZN8I5be9e+Of9R07Mb7kHQvpPSqxGeCkFzZXpUxRP2HxljAfKcUO3
         eq0E2V7q+pQfG0UrBOo9mS34bY9K5m/HCEYFFTmk7gHxyEqt6uOW24FwY3ZWka7CsQiW
         whA/itd93zceF2I0AE9BKUF8KpM1XaY5OY0jJO5nR3TsDMcybnMr0d1VFJTZFPz8I0V6
         Q3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678463114;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dKsqBboH0bFfsTwY9easxEwnBQtTjr8MI+NIbG15Q4E=;
        b=eoyVtOe2Lweo0byJOKAkCs0IUAivl3XP4945MousK9wSyIvFwpJg1wirLrBeOjDynt
         XRBj/mRfxRvkDIYAcfUbbDNt4pjki7sF3dePmPQdwvAws8p12aNdQSjj0ApsLhXCRF/K
         Umnm8zFUDMsdIb5DStw/6WPy/VGERbk2GMeBcieSbEolXozr+76kCYL+7WFlx4qGULR2
         c0Dx5JTBSyxEfo7HSeUbMJnSEx3uO4hAy9uP8CSq8ip7HaApErJDSWV8JGdRHHlk63v/
         rT8Jqv3QEvc4Pddk1RThmSM1h8lhTiPIuujdXk3Yx34pz7+WoeTX9oo4s7Cq8+h/ZZtI
         Rw1g==
X-Gm-Message-State: AO0yUKU0x4//ajBR5ntx9V5u1g56LnIb/cmI8AiRHAy0iF1r8fm40BUH
        7WNBd5j4WRbquViXtCReW9M=
X-Google-Smtp-Source: AK7set8UCP7CXFtZRJTw9jeIdrSGuxZr9PNgk2NyFKxZiectyGBgI60/Klaio3VkmZe8Wx7bdsg12Q==
X-Received: by 2002:a05:600c:450c:b0:3eb:966e:b2a5 with SMTP id t12-20020a05600c450c00b003eb966eb2a5mr3155154wmo.17.1678463113930;
        Fri, 10 Mar 2023 07:45:13 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id n6-20020a5d6b86000000b002c54c8e70b1sm133394wrx.9.2023.03.10.07.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:45:13 -0800 (PST)
Date:   Fri, 10 Mar 2023 17:45:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] dsa: marvell: Provide per device information about
 max frame size
Message-ID: <20230310154511.yqf3ykknnwe22b77@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-2-lukma@denx.de>
 <20230310120235.2cjxauvqxyei45li@skbuf>
 <20230310141719.7f691b45@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310141719.7f691b45@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 02:17:19PM +0100, Lukasz Majewski wrote:
> This is the "patch 4" in the comment sent by Russel (to fix stuff which
> is already broken, but it has been visible after running the validation
> code):
> 
> https://lists.openwall.net/netdev/2023/03/09/233

Ok, so nope, what I was talking about here (MTU 1492) is *not* what you
have discussed with Russell in patch 4.

What I was talking about is this:
https://patchwork.kernel.org/project/netdevbpf/patch/20230309125421.3900962-2-lukma@denx.de/#25245979
and Russell now seems to agree with me that it should be addressed
separately, and prior to the extra development work done here.

It looks like it will also need a bit of assistance from Andrew to
untangle whether EDSA_HLEN should be included in the max_mtu calculations
for some switch families only, rather than for all.
