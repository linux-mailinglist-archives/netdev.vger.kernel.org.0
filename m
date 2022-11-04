Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAB2619F30
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiKDRr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiKDRrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:47:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C6B47309;
        Fri,  4 Nov 2022 10:47:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2FDC622D9;
        Fri,  4 Nov 2022 17:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CBAC433C1;
        Fri,  4 Nov 2022 17:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667584062;
        bh=xjAqegmCvTQ49AKDR4KnqMNjCa6Tok/j4l/x/R+4LSU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uKNMmySjpSocawQvBK9OX7MnYYevENKqIAV9NSwha6GZ5f6m8GIB8M6X7Wu4EEo6A
         ejQeIpwISQdmOcVphuyuMcE+cDXSm4wUEUDirLKTC77dtobipvKUNeoMytXkloo7GO
         uXW6nZPqM43etAku72qrzt3SIteKsxqF3pg0YsPySZVU2pXeuVtZpT1ry7t3Wg1bjh
         mmQ49zQ0Pmu9Mqvx93q5gjBI0YqlpaP6xxlyMt81fL381pzzUCc8H05R1f6TE8dkJ1
         pAkLRHdN7pf54LckmgURSj1Nu0pnM/AyraAg6JGwl1lgXFpYNtI6D5Ofko78mpJmMh
         3FkTQ6q1ESDMA==
Date:   Fri, 4 Nov 2022 10:47:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Adrien Thierry <athierry@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/net: give more time to udpgro bg processes to
 complete startup
Message-ID: <20221104104740.3191c652@kernel.org>
In-Reply-To: <da8cb23e4b0909a3bdde8e267b4df7df4c1575f7.camel@redhat.com>
References: <20221101184809.50013-1-athierry@redhat.com>
        <20221103204607.520b36ac@kernel.org>
        <da8cb23e4b0909a3bdde8e267b4df7df4c1575f7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Nov 2022 09:54:10 +0100 Paolo Abeni wrote:
> Then it will be less straigh-forward for the running shell waiting for
> all the running processes.=C2=A0

The usual solution for that is to write the pid of the daemonized
process to a file, no?

> Another option would be replacing the sleep with a loop waiting for=20
> the rx UDP socket to appear in the procfs or diag interface, alike what
> mptcp self-tests (random example;) are doing:
