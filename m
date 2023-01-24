Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0AC6790C5
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbjAXGUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbjAXGUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:20:36 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDC83CE03
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:20:32 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-50642ea22adso7686607b3.4
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dyXFn2lup2sLjbD/KpbuX1CCPdcq3g2m2cieMlwaGx8=;
        b=dRGgaBE05wZKoyL6PoURa8kyaU0QE4JoRH+/PrGTgBN+7o02KYKA8AEGY4JbFuQi3W
         ysgjKlaBLsGOf3ixLDGZDE5TgKPszGZmyXMhx9S2usD4SDjnzOGBKXEIfpZOOEWxY4Tf
         d7qUCDjs+If7k+yg1zW58iaoJX17+YlkX5GrhA4fBjuh2FMNxKxmumklwY345oy6FOGh
         Jx1ZACuiHso9surRyTdhrNqFjWt7Brel0z4VK0LSmV1SjkN8XBePXOHMm/jmncozW+aJ
         07ufrYX9ZKBfR1Vd0XbIPLedajv3eaUDv4UGm1C1SGeKKh/2lW7XT5FYToHiuYY0ik9a
         6dyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dyXFn2lup2sLjbD/KpbuX1CCPdcq3g2m2cieMlwaGx8=;
        b=2CY88CUEK0kcFqax24mGe0CNbhHqJbvkhBER7AeXat4RFlhSmptXmJZg5RoSajLMLV
         YrS/uNk7L9BB+zpVSJ9R/zNPcxkCup4awZWvxbUAVYEsSqZaGtKGL6tzTgmJDzyFRzVv
         mYeF3QJ1Gt+BqC0deAuVi45nN4d1Kdg3W8FEOE2SCxamoJnsehSR4S7fKmA5k75v90PL
         XJazlawjbwVzMMJlvN4HVoTkBMzFiAVqi+bqHQTKQbLD0246zN44QS+0gr3hAxrDLeWv
         zNYqPt4okEjjPDgTKPBSkXx0O1S7Xkz7qecEel/iGa88TGpKUXjrPcV91aV+qsSs0TCP
         HjHA==
X-Gm-Message-State: AFqh2kqzZRQjdLJX/sbErfVWinNL4W504EzZYirWDmvytkphtXGzeTgS
        vrNsb2W15+xxd6YXBhaPCvZFZffRscQ3gXUsmiYQMw==
X-Google-Smtp-Source: AMrXdXvGtDAQmrtie+iMu2/Hn6KcrJFz14ydW887zzDi0fPPgxvoTr6yfqaCAuiC9XOCVbWlCvMM0j/FL50aLD4Ks2U=
X-Received: by 2002:a81:351:0:b0:36c:aaa6:e571 with SMTP id
 78-20020a810351000000b0036caaa6e571mr2408773ywd.467.1674541231962; Mon, 23
 Jan 2023 22:20:31 -0800 (PST)
MIME-Version: 1.0
References: <20230119122705.73054-1-vladimir.oltean@nxp.com> <20230119122705.73054-5-vladimir.oltean@nxp.com>
In-Reply-To: <20230119122705.73054-5-vladimir.oltean@nxp.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 24 Jan 2023 07:20:20 +0100
Message-ID: <CANn89i+-Vp3Za=T8kgU6o_RuQHoT7sC=-i_EZCHcsUoJKqeG9g@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 04/12] net: ethtool: netlink: retrieve stats
 from multiple sources (eMAC, pMAC)
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 1:27 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>

...

>  static int pause_prepare_data(const struct ethnl_req_info *req_base,
>                               struct ethnl_reply_data *reply_base,
>                               struct genl_info *info)
>  {
> +       const struct pause_req_info *req_info = PAUSE_REQINFO(req_base);
>         struct pause_reply_data *data = PAUSE_REPDATA(reply_base);
> +       enum ethtool_mac_stats_src src = req_info->src;
> +       struct netlink_ext_ack *extack = info->extack;

info can be NULL when called from ethnl_default_dump_one()
