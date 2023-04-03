Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9886D43DA
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbjDCLze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjDCLzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:55:33 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE427A9F;
        Mon,  3 Apr 2023 04:55:31 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r11so116253872edd.5;
        Mon, 03 Apr 2023 04:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680522929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6a3C4HyVcJ1+hBTRf358qtUIjTetDrrTnCO3IEBZCWU=;
        b=MarBywG8RwFuY8dvBjXGfCv7rmlthZ83/0XvpN5rXJY0kbQcDBLpazlzrwWxXB4ZRy
         bHqm+TaDdHAnm9OUkKO3KPhDz/IUWwrt7Np0oZDgUNouJlMBenFwLJmK03saCn65rrvt
         bYfMDfUzchDyEpSGLR+PbFuW25KHUa6BZwdpaMEjYtTydWSmfhdRFLFaE91v7J9AXFfb
         HbakQ98LI1f7qa/DCjEtBl4J6tBrY1B0n3pUa6UsVjN7+6CLxmJ0OE7LSwjJZKqpHRO6
         CjhkSzB3weaMuQI+ITYZB2u0wF8+Ro9+AXHEfj0VrBJDkWp3Gciq5E69Uv9SmVbCXeEc
         P8vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680522929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6a3C4HyVcJ1+hBTRf358qtUIjTetDrrTnCO3IEBZCWU=;
        b=cPVRwxFxTBFK7W1zVE4sYK6JYZTYwEH4ChM2QN8Nfx6C4mw+lVuOtNTQoB5rnyws8t
         88j8gqAsAKROQSTGjiTcwdSSaEzlsdoCw5BND2jxsCSJ1PfQBW3oSU8AZim9os+cuYRF
         wC+y6jlHEQk2rV2RDec0N5pPuuh9FbaAKcaLwsyjnYyjEsT8HU1QUKQrdK+cWEfMgBbj
         IETGjQVvoeri7VkQfZh6B9DBSXROld/Z1iTbpheOsnwoEzA5dRvbmeDEz8CyBnyZvvpi
         NS+GF1CtmurS5WBVCt2fScQIweB2OQ6d51R3npqYFNbG2q70JFc7gcdeu+mnEDBFvRBi
         q+LQ==
X-Gm-Message-State: AAQBX9e2PSC1ijDI3L6tC62bOsnBjRZE6OQUD3CXTSV+eRAe7wulYSWh
        IKkUSSDpfSnFkQIzmatV8+M=
X-Google-Smtp-Source: AKy350a9DUZelfyu+kfJC0Zh9d5n3LzN73d8R9FYm5yoVPT0c0C1CXkwH+ICvQYPbIq2EZElLZFdfA==
X-Received: by 2002:a17:906:5010:b0:92a:77dd:f6f with SMTP id s16-20020a170906501000b0092a77dd0f6fmr37352471ejj.73.1680522929433;
        Mon, 03 Apr 2023 04:55:29 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id z9-20020a17090665c900b0093fa8c2e877sm4410215ejn.80.2023.04.03.04.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 04:55:29 -0700 (PDT)
Date:   Mon, 3 Apr 2023 14:55:26 +0300
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
Subject: Re: [PATCH 0/7] dsa: marvell: Add support for mv88e6071 and 6020
 switches
Message-ID: <20230403115526.gpp7aymvnk4gyx6e@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309125421.3900962-1-lukma@denx.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Lukasz,

On Thu, Mar 09, 2023 at 01:54:14PM +0100, Lukasz Majewski wrote:
> This patch set provides following changes:
> 
> - Provide support for mv88e6020 and mv88e6071 switch circuits (the
>   "Link Street" family of products including added earlier to this
>   driver mv88e6250 and mv88e6220).
> 
> - Add the max_frame size variable to specify the buffer size for the
>   maximal frame size
> 
> - The above change required adjusting all supported devices in the
>   mv88e6xxx driver, as the current value assignment is depending
>   on the set of provided callbacks for each switch circuit - i.e.
>   until now the value was not explicitly specified.
> 
> - As the driver for Marvell's mv88e6xxx switches was rather complicated
>   the intermediate function (removed by the end of this patch set)
>   has been introduced. It was supposed to both validate the provided
>   values deduced from the code and leave a trace of the exact
>   methodology used.

The problem with MTU 1492 has been resolved as commit 7e9517375a14
("net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250,
6290"), is present in net-next, and as such, you are free to resubmit
this patchset on top of the current net-next.gi/main whenever you feel
like it, no need to wait for a merge window.
