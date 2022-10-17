Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AB4601688
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 20:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJQSoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 14:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJQSoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 14:44:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D03C733CB
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 11:44:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8328611F6
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 18:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA84C433D6;
        Mon, 17 Oct 2022 18:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666032249;
        bh=RSw1Ee9Jzp6CdY6XsqbgznAQZJtYbKDGvohMoQBljXQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ghGMLNKxcd/uL5ao80hSnM4VSK2VbPigAi/Rd7M+zWHIc5dK92/NLtE0c01r3xuTI
         qPCCsMC+6PKMG5OQzZ+L0QAoI6DQmfV2XnRwJU+BxSpgqdQNUMRjsiBRU1keUMQ0xY
         VAuq7OAbuAhBowqT2k4hTIrAWZ7c/nGzHmn236Cy+I7/3G4LYNcDV02vs47HF2aKzy
         FYc+mopT8ySLzIICicntJGFlk2/gR2BydDyvFheBCSCLiWDzyup//qN8ZWd7GM2sog
         ItLn710ScYEXCHeltiryThYjO3bJRxFFCbvDlD0sm422jIgTys0nX5FdQ2h74nOLTj
         Hs3cDQSjZq7Rw==
Date:   Mon, 17 Oct 2022 11:44:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, ecree@xilinx.com,
        netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com, johannes@sipsolutions.net,
        marcelo.leitner@gmail.com
Subject: Re: [RFC PATCH net-next 1/3] netlink: add support for formatted
 extack messages
Message-ID: <20221017114408.1c1bd0a7@kernel.org>
In-Reply-To: <43513470-fd59-4d18-f66e-0aecfcfc8404@gmail.com>
References: <cover.1665147129.git.ecree.xilinx@gmail.com>
        <a01a9a1539c22800b2a5827cf234756f13fa6b97.1665147129.git.ecree.xilinx@gmail.com>
        <Y0gKzgmWSgw/+4Oc@nanopsycho>
        <43513470-fd59-4d18-f66e-0aecfcfc8404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Oct 2022 13:00:55 +0100 Edward Cree wrote:
> > I wonder, wouldn't it be better to just have NL_SET_ERR_MSG_MOD which
> > accepts format string and that's it. I understand there is an extra
> > overhead for the messages that don't use formatting, but do we care?
> > This is no fastpath and usually happens only seldom. The API towards
> > the driver would be more simple. =20
>=20
> Could do, but this way a fixed string isn't limited to
>  NETLINK_MAX_FMTMSG_LEN like it would be if we tried to stuff it
>  in _msg_buf.  Unless you're suggesting some kind of macro magic
>  that detects whether args is empty and chooses which
>  implementation to use, but that seems like excessive hidden
>  cleverness =E2=80=94 better to have driver authors aware of the
>  limitations of each choice.

No macro magic, if we wanna go the extra mile we'd need to run some
analysis. We can choose the limit based on the longest message today.

If spatch could output matches that'd make the analysis pretty trivial
but IDK if it can :S
