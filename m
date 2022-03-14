Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B904D8A83
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 18:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243169AbiCNRJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 13:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243128AbiCNRJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 13:09:06 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2BDDFB8;
        Mon, 14 Mar 2022 10:07:52 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a8so35508274ejc.8;
        Mon, 14 Mar 2022 10:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B8S5CePBfzrVCN/ZCs2BTxWuc9mvMQ9JoCGkKm6n008=;
        b=JddOuH6IACYyaa/tIi4d1gXpCB3xrMraVpH2XUdtQatNapgahGumBtAtcfu0gaVfVf
         mqwtx4llIbo3SomPBbJgGPUwYvfaXGOcOuGqqdMcc3d7qAd3n8Spg43A2ZbenDG2kxUK
         9wPgmy2V+kw43rle8itGKuJXYe0FlZyFrvytPNB1wnw+Xlz5qlgPor6K1RjsGVP/bxzo
         9rMg+ElMLBhrj+uAhZe9zjrtNgObr+hLPHBFSIp2EppxsdglnssMcYq5P164i2ivBBSi
         3ldreuPWdV1810u6wrWU5cX0f579X/uLvA76/Mvsl/F58Kt5u+LPXK/SVz8780uLM75Q
         ffZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B8S5CePBfzrVCN/ZCs2BTxWuc9mvMQ9JoCGkKm6n008=;
        b=xFW+T0SyDX2vqqhTLP8Ae78rbT8d75K3R8TatHp6uw7n86YqOFdeBvq4Ihmg7PK90s
         sxItAiCezic/ZDRYmyXZxmZAeEfyOhkmnlK54SNaYvSkywrf2e8kUqPgD2RABbAOYdea
         P9Dk69yyVekKnmEpCkVu+Qmcw2VxdS1+wfE3NybuCBtf7tTjbjYHIOMv4H1pdy9CFM9K
         Qnvmx6bqLG0RXv8AvUtU0dguCsZtD0NLP61UylD4jR0yItUsUn7OT7KAdBYrRqWeMtVv
         BPh7od2IQ/mMqb0gwL2ZM9CSc89eJEuIJvComQnLQmnbVEuuYFdsPO8gV2hQRbNjbwKt
         XPKQ==
X-Gm-Message-State: AOAM533Vje7NmMKL66bWngvuocFAIWFhqcY1/ueWAOeSWoq8P0QbvYC5
        Cv/SF71wyNfbJ4QAhwUFk94=
X-Google-Smtp-Source: ABdhPJzfk/wrcwCi8JX2pmOKMrdjei5CfYv8dgjn6RSGi90CG3GPik3sk3XCPGonC3haROHhc+j8FA==
X-Received: by 2002:a17:906:9b85:b0:6db:ab80:7924 with SMTP id dd5-20020a1709069b8500b006dbab807924mr12533799ejc.160.1647277666339;
        Mon, 14 Mar 2022 10:07:46 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id uz4-20020a170907118400b006dab1ea6e3asm7021586ejb.51.2022.03.14.10.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 10:07:45 -0700 (PDT)
Date:   Mon, 14 Mar 2022 19:07:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v3 net-next 10/14] net: dsa: Pass VLAN MSTI migration
 notifications to driver
Message-ID: <20220314170744.ugirixeq5t7ddcgo@skbuf>
References: <20220314095231.3486931-1-tobias@waldekranz.com>
 <20220314095231.3486931-11-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314095231.3486931-11-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 10:52:27AM +0100, Tobias Waldekranz wrote:
> Add the usual trampoline functionality from the generic DSA layer down
> to the drivers for VLAN MSTI migrations.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
