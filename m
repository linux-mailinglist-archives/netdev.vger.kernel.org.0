Return-Path: <netdev+bounces-4775-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38B2670E2BA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00F5F1C20C3A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C25C209AD;
	Tue, 23 May 2023 17:27:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D734C91
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 17:27:23 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34CFE0;
	Tue, 23 May 2023 10:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=H+WArbHhZgiUK30ewBOOf9ulbLcQ4bIxED3JjDQ9fZQ=; b=ywPvbtsPuWR/IL0hjrQ0qzL5l9
	ShZiYiA3iizm4D5wFLGu5VudjjYwPqxS2QfYzjlkFIVP2QIU4NRfX49KRcXWQ4ZzfiCfTcpdf2ypE
	KwkzjX1qlRtniJdzGW+nx7SGyDyY1k11gOPcjEui6ysAmUg/SII6w9VdAIb+NQanjvbM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1Vmf-00DiNE-E4; Tue, 23 May 2023 19:26:53 +0200
Date: Tue, 23 May 2023 19:26:53 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lukasz Majewski <lukma@denx.de>
Cc: Vladimir Oltean <olteanv@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] dsa: marvell: Add support for mv88e6071 and 6020
  switches
Message-ID: <89fd3a8d-c262-46d8-98ad-c8dc04fe9d9c@lunn.ch>
References: <20230523142912.2086985-1-lukma@denx.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523142912.2086985-1-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 04:29:09PM +0200, Lukasz Majewski wrote:
> After the commit (SHA1: 7e9517375a14f44ee830ca1c3278076dd65fcc8f);
> "net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250, 6290" the
> error when mv88e6020 or mv88e6071 is used is not present anymore.

>   dsa: marvell: Define .set_max_frame_size() function for mv88e6250 SoC
>     family

Hi Lukasz

commit 7e9517375a14f44ee830ca1c3278076dd65fcc8f
Author: Vladimir Oltean <vladimir.oltean@nxp.com>
Date:   Tue Mar 14 20:24:05 2023 +0200

    net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250, 6290
    
    There are 3 classes of switch families that the driver is aware of, as
    far as mv88e6xxx_change_mtu() is concerned:
    
    - MTU configuration is available per port. Here, the
      chip->info->ops->port_set_jumbo_size() method will be present.
    
    - MTU configuration is global to the switch. Here, the
      chip->info->ops->set_max_frame_size() method will be present.
    
    - We don't know how to change the MTU. Here, none of the above methods
      will be present.
    
    Switch families MV88E6165, MV88E6191, MV88E6220, MV88E6250 and MV88E6290
    fall in category 3.


Vladimir indicates here that it is not known how to change the max MTU
for the MV88E6250. Where did you get the information from to implement
it?

	Andrew

