Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC58F4DA04E
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350128AbiCOQp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243203AbiCOQp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:45:57 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DC0522FD;
        Tue, 15 Mar 2022 09:44:44 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id p15so42772533ejc.7;
        Tue, 15 Mar 2022 09:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g9frEwzbQdtp2pIYSY0lHpkIaw2YK5YeWDtzUeh3LJo=;
        b=YW8ujBQd5Y2ib1rY1s0oCo5I4Gk2J9cvJzhFA7N9/bnCJo3e2mT4VsdllVnZJ7wj3E
         iTzevAY+YxPHERoDhsltnqkqAk1Tdqc8cxZkJtom2Cy/TsJUykIQrAVAh5mdjgdZ5TQ+
         0PEuuCbnaugdhvpcI7n0K4usinvTxVvDgR5slcXDqaxfvfKA1GgYkvtVC2nNrntUlvC4
         0FHoR93hpkjuYyUENEmwIq+34cQvR7rK6tvTF2nWXkgwqrwIQFJbFkT6tWiqTK8hipeB
         Ko33bAOcvssV3ExDRi1mACftgPGIhVpnLTbBRbxj4X4lveSzc1YBE++4gFFPxoIrteAI
         esNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g9frEwzbQdtp2pIYSY0lHpkIaw2YK5YeWDtzUeh3LJo=;
        b=3SqUgU1Mw9+lKn85BVxzgpC+qutW+bJEdJDjmqEXGBoY6P8gdd5ZxPzWJN+6eZOFn4
         HiQgqfE9HVtba5t2C97/R3h1V33AOYaKXqyziwYvR6ndEWk6Vh6AYWGlVDAsg3AecJGN
         w9bqLi+xcq6atJl+j9HokyfHl40cN10xhktPUjeLHSVfb/89fLQLt0q+3FrltXL6oHDz
         mwBYpIEK9IO+0IUbwEo3UmvVrPcKBlrdj93hW40Mm7O31bp+COtZ2ot0+3PL8+srn9Fa
         DcJpCTkfrOEWRVuZ7CYLLhX8s8mDyJ8LUW2VxEp5yJwmGX/mi2VWNLacSpg3kmdR0wtV
         jqEA==
X-Gm-Message-State: AOAM533vvhuwNy5zRVQBxZiQjxg1d+tm/zcVj7PZwUcLQkBXf5Im3Aa9
        7oheN8uT7VCCHF7u/ujrTxc=
X-Google-Smtp-Source: ABdhPJxNHRbkmNw939PW4oHDhZHgg9mYO+5MS8ksB83Ig9tY3Im3/17D5S6Hj0Hn8HUwrlQdn6JOvQ==
X-Received: by 2002:a17:906:9b94:b0:6db:472:db87 with SMTP id dd20-20020a1709069b9400b006db0472db87mr23954476ejc.624.1647362683249;
        Tue, 15 Mar 2022 09:44:43 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id d7-20020a50cd47000000b004187eacb4d6sm4258072edj.37.2022.03.15.09.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 09:44:42 -0700 (PDT)
Date:   Tue, 15 Mar 2022 18:44:41 +0200
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
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 12/15] net: dsa: Handle MST state changes
Message-ID: <20220315164441.sz5jyooa3glnym5p@skbuf>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-13-tobias@waldekranz.com>
 <20220315164249.sjgi6wbdpgehc6m6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315164249.sjgi6wbdpgehc6m6@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 06:42:49PM +0200, Vladimir Oltean wrote:
> Is there a requirement in br_mst_set_state() to put the switchdev
> notifier at the end instead of at the beginning?
> 
> I'm tempted to ask you to introduce br_mst_get_state(), then assign
> old_state = br_mst_get_state(dsa_port_bridge_dev_get(dp), state->msti),

dsa_port_to_bridge_port(dp), excuse me.

> then perform the VLAN fast age only on the appropriate state transitions,
> just like the regular fast age.
