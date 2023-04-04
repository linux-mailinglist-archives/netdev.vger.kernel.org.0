Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9950C6D5566
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 02:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjDDAL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 20:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjDDAL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 20:11:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD4B3C04;
        Mon,  3 Apr 2023 17:11:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D04EF62E10;
        Tue,  4 Apr 2023 00:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6191BC433D2;
        Tue,  4 Apr 2023 00:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680567116;
        bh=uuSqOPHQmO/phVNqjjcQO7JojeZ1EXv1qLqO1MADJU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HpXkxJbZqfA7IBxwToZF5mkkoDAUd1OjOYjK0I3sbbyJifzdCPmw0I4dmjedzfCEV
         N5Hi1xv+f9t7erG/o95cF9JtDLi9RYQgJcgzcPTxHB+bPiycA077XjzQmD0JBW1Aje
         Salgo+nmz3znyP68U6U14oH+ad0x/It/O31ayxqBSd+JWCgHuHEKyrsQbE8qoVBLr7
         dG4fI7OMJ/wonv/z9yT56+7zJoiWj3ZFRK3n0I0bN1h/0+UVYBh9Af9Cl9Ch20IAfO
         /s3oYSGFYHJaC3FxqwXyExJaltQA16GnELgeua75xWfxzwSrV+HIlKG4LJ/q+vkVtY
         19RXDXe1coBew==
Date:   Mon, 3 Apr 2023 17:11:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/9] Add tc-mqprio and tc-taprio support for
 preemptible traffic classes
Message-ID: <20230403171154.1b2d5416@kernel.org>
In-Reply-To: <20230403234339.h2eaomwqoawicaij@skbuf>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
        <20230403110458.3l6dh3yc5mtwkdad@skbuf>
        <20230403143229.415ede88@kernel.org>
        <20230403234339.h2eaomwqoawicaij@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 02:43:39 +0300 Vladimir Oltean wrote:
> > I revived the series. I'm a bit weary about asking Konstantin to make
> > the pw-bot compare tree tags because people change trees all the time
> > (especially no tree -> net-next / net) and he would have to filter out
> > the version.. It's gonna get wobbly. Let's see if the problem gets more
> > common.  
> 
> Thanks. Was it supposed to change state? Because it's still "superseded".

Argh, the bot keeps rescanning and re-marking it as Superseded :(

We have a backup patch tracking method of ... what's unread in 
my inbox. So we should be able to rely on that.
