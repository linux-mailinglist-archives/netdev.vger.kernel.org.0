Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFEDD69D7C3
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbjBUAzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbjBUAzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:55:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096211E9E2;
        Mon, 20 Feb 2023 16:55:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 61B97CE125A;
        Tue, 21 Feb 2023 00:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9220CC433D2;
        Tue, 21 Feb 2023 00:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676940904;
        bh=P5DAjzAAE8SfbTOlPavtkaPO5Sga5zFRCsZcTkEzQJo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bwDkbQXONxJPRg1o+TaXnbqeYpzXKB19OAC7BaHKciaj2sB2x1AFYzjJytghLle73
         XeAYWyqrl2ITN/WWRe64W0RSucJ0Q2uZhxu2sJ3O9X3ULZTQsuA5wHzziHaEnBchL6
         FnrI7Xb30LUijdb657fasGbnTIJaVxD3LzqOd6sz4JiKrn4ym/mNeBKdINaxXaTkGo
         5LL/yPgs4Uc7T7USnaG3R3+9WANkP6WEQ8a6g0BY+xcwcK4+ilcT+L0DqXqveY8/Id
         3wkP5gLQyfle/v2/nirUSoocHX0tilF1AfMPCCh+NvZgWmY/jkCc5bMgTqLoMKavOY
         oFSrvIlYjZteg==
Date:   Mon, 20 Feb 2023 16:55:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/13] Add tc-mqprio and tc-taprio support
 for preemptible traffic classes
Message-ID: <20230220165502.0aee6575@kernel.org>
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Feb 2023 14:23:30 +0200 Vladimir Oltean wrote:
> Some patches should have maybe belonged to separate series, leaving here
> only patches 07/13 - 13/13, for ease of review. That may be true,
> however due to a perceived lack of time to wait for the prerequisite
> cleanup to be merged, here they are all together.

net-next is already closed, sorry :(
