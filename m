Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9C24DC9EB
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 16:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbiCQP2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 11:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235951AbiCQP1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 11:27:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3875D20A96A;
        Thu, 17 Mar 2022 08:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46420B81EF9;
        Thu, 17 Mar 2022 15:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F235C340E9;
        Thu, 17 Mar 2022 15:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647530763;
        bh=2+aIlNYAyt6JrvKd0I5++RrrMWoi4agbOuPrXU84NLQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E6CfVADDbMsrpQ5kFyoPWxZzsvfq8XG3bDxMpwrfROdebKhRKip6GbDvR394A5HXE
         V7J9XIWG2nSDJgAA8H9pQ0B+/OrEzZSiOZavyG20ZG+KL2vWYT5Eciqt/t3pc/jaCZ
         dJV/rWlTSwHigCJXVLi75APEGEnfYN0ObVY4ob29//r5NdK6lEu6k4jOEWq/pqwoHG
         OEmnBR6WK+5fSgSc8trlTc0FhJq4L2e8H92XkVclXFNisVD9g05RncnZEVaao1U3zp
         jWYLaN0ZovLUn9Ez3LsPHmk4U18JyRWAHYWL1+U6zmwCq4hN1J46+VDwrPh5aLmBM1
         wlAwlOe3qIXZQ==
Date:   Thu, 17 Mar 2022 08:26:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 3/4] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20220317082601.00a45d2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220317093902.1305816-4-schultz.hans+netdev@gmail.com>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
        <20220317093902.1305816-4-schultz.hans+netdev@gmail.com>
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

On Thu, 17 Mar 2022 10:39:01 +0100 Hans Schultz wrote:
> This implementation for the Marvell mv88e6xxx chip series, is
> based on handling ATU miss violations occurring when packets
> ingress on a port that is locked. The mac address triggering
> the ATU miss violation is communicated through switchdev to
> the bridge module, which adds a fdb entry with the fdb locked
> flag set.
> Note: The locked port must have learning enabled for the ATU
> miss violation to occur.
>=20
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>

drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c:32:5: warning: no previous =
prototype for =E2=80=98mv88e6xxx_switchdev_handle_atu_miss_violation=E2=80=
=99 [-Wmissing-prototypes]
  32 | int mv88e6xxx_switchdev_handle_atu_miss_violation(struct mv88e6xxx_c=
hip *chip,
     |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
