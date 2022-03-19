Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A48F4DEA3B
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 20:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243950AbiCSTCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 15:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243962AbiCSTCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 15:02:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125C28CCEB;
        Sat, 19 Mar 2022 12:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C2F7CE02C1;
        Sat, 19 Mar 2022 19:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F50C340EC;
        Sat, 19 Mar 2022 19:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647716446;
        bh=SLhqOb3+6D7AkA2ZMJgiGQbfMkpoxtBJVOtPeBrWzGY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pot78D0+1COTWvvVguRMa1jMzLgKMTbjKP4xmjODRO5+Guhy/uGO4sS6F3Ez1zbqF
         krWAGbKW6a2W5kaCeJIXMVYEFR+UoQ6eZpSg0gMa7h794Y0t/ak915umS4dKvXwi9e
         jEv25ICqKpVzdtfddiosS8RmvyUgR6N/GNN2Hob9ZP8qbZTdZnKW8nOkXyT8hDfiS3
         mAjsKZ2G6QfOfpsQVrSfzRur7WbYE7pCe3IQ5rOUN0R1NNesBNEJAIXgfj018WAt8F
         r0cAiSlHY3GgIhzcixlQgb7e0h4FQiw0Ng2TZ43YSE/v0rvtoOhrjQR98rn7Caq9WB
         4CxnFmsa9T33A==
Date:   Sat, 19 Mar 2022 20:00:41 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Fill in STU support for
 all supported chips
Message-ID: <20220319200041.12d6d1c8@thinkpad>
In-Reply-To: <20220319110345.555270-1-tobias@waldekranz.com>
References: <20220319110345.555270-1-tobias@waldekranz.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Mar 2022 12:03:45 +0100
Tobias Waldekranz <tobias@waldekranz.com> wrote:

> Some chips using the split VTU/STU design will not accept VTU entries
> who's SID points to an invalid STU entry. Therefore, mark all those
> chips with either the mv88e6352_g1_stu_* or mv88e6390_g1_stu_* ops as
> appropriate.
>=20
> Notably, chips for the Opal Plus (6085/6097) era seem to use a
> different implementation than those from Agate (6352) and onwards,
> even though their external interface is the same. The former happily
> accepts VTU entries referencing invalid STU entries, while the latter
> does not.
>=20
> This fixes an issue where the driver would fail to probe switch trees
> that contained chips of the Agate/Topaz generation which did not
> declare STU support, as loaded VTU entries would be read back as
> invalid.
>=20
> Fixes: 49c98c1dc7d9 ("net: dsa: mv88e6xxx: Disentangle STU from VTU")
> Reported-by: Marek Beh=C3=BAn <kabel@kernel.org>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Tested-by: Marek Beh=C3=BAn <kabel@kernel.org>
