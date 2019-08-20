Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2699681A
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 19:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbfHTRze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 13:55:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730423AbfHTRze (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 13:55:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BC99C308402D;
        Tue, 20 Aug 2019 17:55:33 +0000 (UTC)
Received: from gondolin (ovpn-116-201.ams2.redhat.com [10.36.116.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 935161877E;
        Tue, 20 Aug 2019 17:55:25 +0000 (UTC)
Date:   Tue, 20 Aug 2019 19:55:19 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Parav Pandit <parav@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
Message-ID: <20190820195519.47d6fd6a.cohuck@redhat.com>
In-Reply-To: <20190820111904.75515f58@x1.home>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>
        <20190808170247.1fc2c4c4@x1.home>
        <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
        <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813085246.1d642ae5@x1.home>
        <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813111149.027c6a3c@x1.home>
        <AM0PR05MB4866D40F8EBB382C78193C91D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814100135.1f60aa42.cohuck@redhat.com>
        <AM0PR05MB4866ABFDDD9DDCBC01F6CA90D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814150911.296da78c.cohuck@redhat.com>
        <AM0PR05MB48666CCDFE985A25F42A0259D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814085746.26b5f2a3@x1.home>
        <AM0PR05MB4866148ABA3C4E48E73E95FCD1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <AM0PR05MB48668B6221E477A873688CDBD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190820111904.75515f58@x1.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 20 Aug 2019 17:55:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 11:19:04 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> What about an alias based on the uuid?  For example, we use 160-bit
> sha1s daily with git (uuids are only 128-bit), but we generally don't
> reference git commits with the full 20 character string.  Generally 12
> characters is recommended to avoid ambiguity.  Could mdev automatically
> create an abbreviated sha1 alias for the device?  If so, how many
> characters should we use and what do we do on collision?  The colliding
> device could add enough alias characters to disambiguate (we likely
> couldn't re-alias the existing device to disambiguate, but I'm not sure
> it matters, userspace has sysfs to associate aliases).  Ex.
> 
> UUID=$(uuidgen)
> ALIAS=$(echo $UUID | sha1sum | colrm 13)
> 
> Since there seems to be some prefix overhead, as I ask about above in
> how many characters we actually have to work with in IFNAMESZ, maybe we
> start with 8 characters (matching your "index" namespace) and expand as
> necessary for disambiguation.  If we can eliminate overhead in
> IFNAMESZ, let's start with 12.  Thanks,
> 
> Alex

I really like that idea, and it seems the best option proposed yet, as
we don't need to create a secondary identifier.
