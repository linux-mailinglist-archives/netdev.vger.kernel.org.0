Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9665710F0
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 05:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiGLDi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 23:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGLDi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 23:38:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4246711A31
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 20:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F01E9B81648
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AEAC3411E;
        Tue, 12 Jul 2022 03:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657597134;
        bh=q4Yku20FWRL/AX9vTxKZM+7Tt7fNYSI7novuX8Q7HN8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bsFHtELri0dS4AsXqNsrTrW8mHSYL7zzHawWD4q96+cYnlpGp7y0fIoZHvVF5v/q1
         aa7UKHvOOST2qft1q/D5BXqLUZUM+jhiCXueIs5PO4FkfT32yJTwY0EdZchXHdh81g
         jAJoQyPV+aQo+XM5xEfRZKPp2w6U6Iq5apPJ4WDYHn+BzzJWElgU/C6oUSV73IYeQi
         fySco844YI14DUfFUUrpNtjLwVfWEcfb0J4jsjS1qlG9w2cuizbnE2uWggQs5B4WUF
         uZ3ERsjXIYmVtikquamLbYrP4NZViZPwAgrqfO9jY1bModd54FKPGxnbNz8sz8lZ6X
         jQvhpLNoILqbw==
Date:   Mon, 11 Jul 2022 20:38:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, Yanghang Liu <yanghliu@redhat.com>
Subject: Re: [PATCH net] sfc: fix use after free when disabling sriov
Message-ID: <20220711203853.72f7565d@kernel.org>
In-Reply-To: <20220711134520.10466-1-ihuguet@redhat.com>
References: <20220711134520.10466-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jul 2022 15:45:20 +0200 =C3=8D=C3=B1igo Huguet wrote:
> Use after free is detected by kfence when disabling sriov. What was read
> after being freed was vf->pci_dev: it was freed from pci_disable_sriov
> and later read in efx_ef10_sriov_free_vf_vports, called from
> efx_ef10_sriov_free_vf_vswitching.
>=20
> Set the pointer to NULL at release time to not trying to read it later.

Please add a Fixes tag and repost. Does ef100 need the same fix? :(
