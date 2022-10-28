Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E13610869
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 04:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbiJ1Cs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 22:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiJ1Cs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 22:48:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C99ABEAF7
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 19:48:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40AE5B8282E
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 02:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514CCC433D6;
        Fri, 28 Oct 2022 02:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666925303;
        bh=K0ufjV1PF3FgkvldmXML0s9M5Vw5fBCKEOemPNFM/3I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZqxsKRh+1TJBzmyofDOCF2v6R6ZHPnv1t8QeCfzw6Z/Rbm34VV+osunV/oF29+QhA
         AzuUdlswl+8ay3UH+UZfEV7qOu8DmxsvtGhrCjmanBnYO3NNf0oP0UlWy5rihsACBz
         O6QhPmRPPR9nMFSiqY10a8Rh2nOE6fG0hGuN9W3rC4QRxltdNQVCI3WwLUeCHKQ78d
         JIuf3lXU5jeJXMgpNgeeaHGiAHdiArFOGjyE1YZC1gG1A+2vk4IDsIDvMcyBB26xu1
         266+8s3THQgbX97I3R+tUGSqai2AZF5QsKVzcqciEue+SwhCAiHJ1hGTHoXaw84nnc
         +V19x0mVGWwkA==
Date:   Thu, 27 Oct 2022 19:48:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org, alexander.duyck@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        vinicius.gomes@intel.com, sridhar.samudrala@intel.com,
        Maor Dickman <maord@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [net-next PATCH v3 1/3] act_skbedit: skbedit queue mapping for
 receive queue
Message-ID: <20221027194822.24d12e12@kernel.org>
In-Reply-To: <43d8bfd6-09e8-5e18-03cf-979c518d99c0@nvidia.com>
References: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
        <166633911976.52141.3907831602027668289.stgit@anambiarhost.jf.intel.com>
        <c04ab396-bea0-fcb2-7b5a-deafa3daffa5@nvidia.com>
        <20221026091738.57a72c85@kernel.org>
        <56977d26-5aca-1340-baba-5ba0cdbb9701@nvidia.com>
        <43d8bfd6-09e8-5e18-03cf-979c518d99c0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 11:10:21 +0300 Roi Dayan wrote:
> going to do this change, which I didn't remember to do from the start.
>=20
> static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] =3D {
>         [FLOW_ACTION_ACCEPT] =3D &mlx5e_tc_act_accept,
>         [FLOW_ACTION_DROP] =3D &mlx5e_tc_act_drop,
>         [FLOW_ACTION_TRAP] =3D &mlx5e_tc_act_trap,
>         [FLOW_ACTION_GOTO] =3D &mlx5e_tc_act_goto,=20

=F0=9F=91=8D
