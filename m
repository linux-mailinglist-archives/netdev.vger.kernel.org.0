Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4A83B7160
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 13:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhF2Lic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 07:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbhF2Li1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 07:38:27 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E26DC061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 04:36:00 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gn32so35864760ejc.2
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 04:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RNo2v+FbgzoADDcZDwSBQCTuCZYX8mLztqFJiqkXhoU=;
        b=tgH5/g6SubUKRNiz76sbX1sUTRxAgsb0Cob1ELh2JqfyVBb7GO1BdzwIeLXCx6RJE0
         qoooni1Mk2pc35QEsXFckRPR84bwdrt9mCUDOX4SVxQicRxBcy5oAdWqEICxOjFjXyFV
         om8/r3jT+aZ5GyWxoxuXnSGwAWdgn+JrZsp35XK6yP7X0MdDH5jn5m72BsuxMP6uswrn
         4yXh1pTpEGr56rS5dfS5AsEqzImvBWrNl3/x2yD1u2gaT9IUNXr+jaHFpivbAZ/Vw4TH
         NrWaNLFdkUNHhUOpudZ4+QlqE+bnccvQJP/cjKe1MzeSqXCIM6vZaSzsAcmA6uwlMRrf
         RtRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RNo2v+FbgzoADDcZDwSBQCTuCZYX8mLztqFJiqkXhoU=;
        b=UFGxvzqEfMxNqDj6meMt7bNQECCrU10I/E8WjSlBEoeNxW6v5ysLiFD6/sY30PFlzb
         jjw1t+Dvc4OdUDoKy1Lri/VSZpm1cZm2DlrFpI3oJrUwiOw7u+1EmEIwr9BxTvSzDo2L
         qMMF4xb4dRlqXi1n2iFqMRsEU7rzow5Sm1hh7Q519fRik8wC6kQ+dXkWornIL6r+dDnK
         WmO26Hdmcj+41I974WSa7K8+sRnke0pHL5BPqN57u3Tk3JuIzZsIUeuVm+0XGHCep01c
         Ga/7Zo4XAe09DCply4jix+9are3qEUdWtXVxD4HlhRN3BfRRzPk3KPdJzFZxJCclDC3z
         0bdA==
X-Gm-Message-State: AOAM532O5b4owqFteVMIdIWUXkoenbVhIuhinsr01OzhpDWxcS0h4lPm
        SquZNP12KeiJm07Q12Pksik=
X-Google-Smtp-Source: ABdhPJwUR7xC6xiOKoQZcBqlIZBon2Y8NnCE/95PZX+urJoClsq84dNk3DxGrSw2ccymrjn3jszPIQ==
X-Received: by 2002:a17:906:110b:: with SMTP id h11mr15132835eja.356.1624966559161;
        Tue, 29 Jun 2021 04:35:59 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id n11sm8445342ejg.43.2021.06.29.04.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 04:35:58 -0700 (PDT)
Date:   Tue, 29 Jun 2021 14:35:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v4 net-next 01/14] net: bridge: switchdev: send FDB
 notifications for host addresses
Message-ID: <20210629113557.eu5it6lfsnnaioej@skbuf>
References: <20210628220011.1910096-1-olteanv@gmail.com>
 <20210628220011.1910096-2-olteanv@gmail.com>
 <984a649e-38fb-9962-e7dd-3cd441a83ec9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <984a649e-38fb-9962-e7dd-3cd441a83ec9@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 01:40:20PM +0300, Nikolay Aleksandrov wrote:
> > @@ -117,18 +118,16 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
> >  		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
> >  		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
> >  	};
> > -
> > -	if (!fdb->dst)
> > -		return;
> > +	struct net_device *dev = fdb->dst ? fdb->dst->dev : br->dev;
> 
> you should use READ_ONCE() for fdb->dst here to make sure it's read only once,
> to be fair the old code had the same issue :)

Thanks for the comment. I still have budget for one patch until I hit
the 15 limit, so I guess I'll do that separately before this one.
Just trying to make sure I get it right. You want me to annotate
fdb_create(), br_fdb_update(), fdb_add_entry() and
br_fdb_external_learn_add() with WRITE_ONCE() too, right?
Can I resend right away or did you notice other issues in the other
patches?
