Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA12CFC18
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 16:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfJHOOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 10:14:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37165 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfJHOOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 10:14:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id f22so3317306wmc.2
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 07:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F7vwu9MZi//q/48C50FDT7qr1HC0MbdJ6vHKiJPZKHA=;
        b=PvclAqKiDAmE2vXXC13dnbfEw1yAzOPwmeqq0Zz45Etlx4ZJbElqgIAJoRvSQiaXFU
         6fp67ptYcdBGqqaFnNPY76EUEkjma8eYx7vPhGDKjBFDWpiJMPbbUDexqc6U33EpcVM2
         zFTCzqJKCT42lXukWjouaSQd3++3cyzcvGCQoLFFZ1mFzBievNJHXNlj3WFVFpOjOmnS
         bGEwrI3SH+QZJzPzUDcKyyO6MOM69hARn7ok9F3yiP7MUyPgLYBIt1vKIMyGIo86FVW6
         rxBTsj7CJeoSfrObFfn4O43rCgN7BIug6vYMUo7RJcr68uTqBnq6D+r3YSyjrS3dbtvC
         FE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F7vwu9MZi//q/48C50FDT7qr1HC0MbdJ6vHKiJPZKHA=;
        b=V/SUSyAQBy3T9FSEHeNjJCzOJNj0mznKOsMLdrmTGNE+JoPFdStlVtoIcCzvCY2BK3
         RhK0GPpn4UUhYKnKSdFsoSbLSFoZBTCjSg1XjvoVkBshzwuJTCEdD7QFC94EVUQiH7Br
         /Nj1cTNMxLE8EVShO97nXfL3Ru6aCh7e2taHcNV28Y8YX+fs5TzkYYqywVGE7Daxwu2y
         GajcXnCC3WCnberRBgZ5R5i7y3Iix2dbmcNTOS/4AucwX7+dxv+ZJCdKhzSTvv1Rpq9R
         OTtF4SSpzVcZIQS1rkZUSA8OXQ2mt9XVLa0Oj2OavNj+fZhSMnIdZfakb5tMHE2aKK8M
         bEiw==
X-Gm-Message-State: APjAAAVGyogh8OFjHFDzBx9gemWkcijCyjDaqo/8Xt/Wfwygzr76TCqQ
        jpin70++3VMQBa6f5RVlC4Fgl+QQFeA=
X-Google-Smtp-Source: APXvYqzLXX0MSrM0Q3WTvxr+wZqA3aGIYHQ7FPPBgMID4C3uBY3BNu289NXcGX9Vk5vKaFIqzXk0ug==
X-Received: by 2002:a1c:f201:: with SMTP id s1mr3770202wmc.59.1570544040775;
        Tue, 08 Oct 2019 07:14:00 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id x129sm4308026wmg.8.2019.10.08.07.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 07:14:00 -0700 (PDT)
Date:   Tue, 8 Oct 2019 16:13:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] team: call RCU read lock when walking the port_list
Message-ID: <20191008141359.GE2326@nanopsycho>
References: <20191008135614.15224-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008135614.15224-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Oct 08, 2019 at 03:56:14PM CEST, liuhangbin@gmail.com wrote:
>Before reading the team port list, we need to acquire the RCU read lock.
>Also change list_for_each_entry() to list_for_each_entry_rcu().
>
>Fixes: 9ed68ca0d90b ("team: add ethtool get_link_ksettings")
>Reported-by: Paolo Abeni <pabeni@redhat.com>
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>Acked-by: Paolo Abeni <pabeni@redhat.com>

It is not strictly needed a since rtnl is taken, but similar list
iteration in team is designed to work without rtnl dependency.

Acked-by: Jiri Pirko <jiri@mellanox.com>

Thanks!


>---
> drivers/net/team/team.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
>index e8089def5a46..cb1d5fe60c31 100644
>--- a/drivers/net/team/team.c
>+++ b/drivers/net/team/team.c
>@@ -2066,7 +2066,8 @@ static int team_ethtool_get_link_ksettings(struct net_device *dev,
> 	cmd->base.duplex = DUPLEX_UNKNOWN;
> 	cmd->base.port = PORT_OTHER;
> 
>-	list_for_each_entry(port, &team->port_list, list) {
>+	rcu_read_lock();
>+	list_for_each_entry_rcu(port, &team->port_list, list) {
> 		if (team_port_txable(port)) {
> 			if (port->state.speed != SPEED_UNKNOWN)
> 				speed += port->state.speed;
>@@ -2075,6 +2076,8 @@ static int team_ethtool_get_link_ksettings(struct net_device *dev,
> 				cmd->base.duplex = port->state.duplex;
> 		}
> 	}
>+	rcu_read_unlock();
>+
> 	cmd->base.speed = speed ? : SPEED_UNKNOWN;
> 
> 	return 0;
>-- 
>2.19.2
>
