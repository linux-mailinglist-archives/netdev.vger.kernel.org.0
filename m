Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B2C6B25E8
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjCINxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjCINwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:52:50 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6E319118;
        Thu,  9 Mar 2023 05:52:32 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id l1so1914005wry.12;
        Thu, 09 Mar 2023 05:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678369950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MEPzzOTco8F0XZ6j2XkzBBoW/FXirFOe4frZRxNgqgA=;
        b=Fhdv4P1+aH4EuW26fCMYNvV2DyTsd4E3U0S6DDVGuME9pajmGk/a+oxpbhgEEduVKx
         wA+LyDi2RUWyh77q70mi6HCYde+6NjHYh0wJAy3A3QmTiRIzfl0b2mLiuEn+/qZjg/Vy
         /q9URBFxcbvFTYhM9uT4/aXvZDhraBwGTgxYCh9rB+c0PbJNer7+6wB93RkOqlbEBzRr
         C6/S42ep9895fzKt9pX1sxIOPg4kGBQ6EYyuuCWle1DvkKyKCjhQAp8w9S4OEBoeSee7
         XEpgJiJjR6RP8zI2JctCHJuj/0c9h/ZPBCHtf5GKz6DHtY+iLkNf+pZALV8XNovcKXpp
         GtkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678369950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MEPzzOTco8F0XZ6j2XkzBBoW/FXirFOe4frZRxNgqgA=;
        b=j+cEcnWEpv0xwzXQnj+Sbiru3gGNXK+qshnqmq+M9XklUdXrEND0tNjSc7ii42FL5n
         jBvailkOTWVX7caoqXqLEDf8cDN1yBNOr91uv64FbYqfsGN4cUvMiwC+PiLjcMn07wMn
         H4KF26c52XUN6/NA+ZItEMqMWYZyqX6VMKj1kbWIGGj85hI7fOp/+YRRIg7gFpD+k4Rf
         cl9o4oJJrTLQMfIkz+Go29yj/bqFy/grg5uViyMsxYkUQyFULBbkAr7yRo8lfZfPc0Bx
         8pqIkG2h6R/WYeJ+OB01w1sMfhFOBuTwe4PkjWKfJd5DTDNv6Eu5Hs8fVxf9GjmdsRHQ
         cpVQ==
X-Gm-Message-State: AO0yUKUwLT/34ADMWNUCIwyhPpdaYfXwIzyRyxGktkKPh7BGzOgxbgMs
        k9Ya1CTIaUzOM1JTwymsfe8=
X-Google-Smtp-Source: AK7set+R7mRNWL8lBNiwn3d4ckYcO738CPOQt17XTJF1MKCwKj0CXWEynZhuxbeB8yAFjf2sm+d+Aw==
X-Received: by 2002:a05:6000:43:b0:2c7:1603:16c5 with SMTP id k3-20020a056000004300b002c7160316c5mr13310641wrx.67.1678369950483;
        Thu, 09 Mar 2023 05:52:30 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id f2-20020adfdb42000000b002c54fb024b2sm17657612wrj.61.2023.03.09.05.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 05:52:30 -0800 (PST)
Date:   Thu, 9 Mar 2023 15:52:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] dsa: marvell: Add helper function to validate the
 max_frame_size variable
Message-ID: <20230309135227.cmn5j3tundeugyzd@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-6-lukma@denx.de>
 <ZAndSR4L1QvOFta6@shell.armlinux.org.uk>
 <ZAnefI4vCZSIPkEK@shell.armlinux.org.uk>
 <20230309144752.5e62e037@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309144752.5e62e037@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 02:47:52PM +0100, Lukasz Majewski wrote:
> Ok, I will reorder those patches and submit v6.
> 
> Do you have any other comments regarding this patch set?

Please allow for at least 24 hours between reposts. I would like to look
at this patch set too, later today or tomorrow.
