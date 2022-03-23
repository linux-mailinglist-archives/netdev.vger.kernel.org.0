Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7994E5245
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 13:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242652AbiCWMhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 08:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242351AbiCWMhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 08:37:10 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D6D7B54D;
        Wed, 23 Mar 2022 05:35:38 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id u26so1630120eda.12;
        Wed, 23 Mar 2022 05:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mhag5ovtYN4y+cwgnNecwoiRCVi5N408hmW0RyzBoZc=;
        b=kjXzeUm3TWtsI2fQtlaPCwwXNwLwV82onpuzsedxBmluQrcR7w3lB81348DaxiWvOl
         ECCGz7eN+mv8de3iYNHN9x9ksDTBl8ZiMEmpcObnuNEoFMSjNGFW2wFy/xvum6aN6G1H
         ddZ6oAK1Xe7/Q2IgBaWX3JNAaAvZzBO7Ak4ZuS1ue0ongls2rtBa0p5+nTiR+5DK48w+
         +Zb6fAZQZ3TPlbY2rsZQXmoHJBMu5/+YsbAd1XDm4b6YXvMhj4+dDoltJIw9oBXcQMib
         ZS8fEivwhvfcq7+KvC6RvGq1RlgnlIM1g1Uo/n+K1IrLelR/eQNEr9DG78S8HhSOmD9i
         /AVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mhag5ovtYN4y+cwgnNecwoiRCVi5N408hmW0RyzBoZc=;
        b=ylCu7fLLm+cYbWO/oiinnVCdy53PXTBGp3Lsg2OHtPqHXsBYSH3XvaQ6bMBXtCaPW2
         pqat6lUmS4IC97VVdv3YhqGL4iIsMRG6my3EF0JbmmcfIef6PctjgIheqNRTpLoHi3nn
         kw76tDQy5P8Zx7MyeAAniJ02aaxsGi4kKeK6KL02PsPk+3RVbVc3YJR/9is265XSnx+h
         2tjhE2K28P27vu0VrSCUDK0c3FZOkyWBZiLeRUkq4SC7DxN9Y+Pk7iQWBBH1ekc29+Kp
         NzJQe89dhlyncn6a7jd1F1ZILXvlNAMpH0u6V3HN1RsBMtKk7EdpYspWmYY36nqXzxVQ
         1hJA==
X-Gm-Message-State: AOAM532/qtjfI5OU0+9nwTb+BmFXnlKRQxnCJ4SGCClFCfrAX5KUsRsG
        upt3wNtb7DarSQQP4jBndVM=
X-Google-Smtp-Source: ABdhPJzmvXjkIpVDAMHix4xRjwT4qH/ThhEt5Ka8tENBDumGywa3/8It2C5SKpGLaPoqLfK2VTTZMA==
X-Received: by 2002:a05:6402:51d0:b0:419:4121:f41a with SMTP id r16-20020a05640251d000b004194121f41amr16844121edd.117.1648038937130;
        Wed, 23 Mar 2022 05:35:37 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id f5-20020a17090624c500b006cee6661b6esm9892645ejb.10.2022.03.23.05.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 05:35:36 -0700 (PDT)
Date:   Wed, 23 Mar 2022 14:35:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: switchdev: add support for
 offloading of fdb locked flag
Message-ID: <20220323123534.i2whyau3doq2xdxg@skbuf>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-3-schultz.hans+netdev@gmail.com>
 <86o81whmwv.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o81whmwv.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 01:29:52PM +0100, Hans Schultz wrote:
> On tor, mar 17, 2022 at 10:39, Hans Schultz <schultz.hans@gmail.com> wrote:
> > Used for Mac-auth/MAB feature in the offloaded case.
> >
> > Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> > ---
> >  include/net/switchdev.h | 3 ++-
> >  net/bridge/br.c         | 3 ++-
> >  net/bridge/br_fdb.c     | 7 +++++--
> >  net/bridge/br_private.h | 2 +-
> >  4 files changed, 10 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> > index 3e424d40fae3..d5d923411f5e 100644
> > --- a/include/net/switchdev.h
> > +++ b/include/net/switchdev.h
> > @@ -229,7 +229,8 @@ struct switchdev_notifier_fdb_info {
> >  	u16 vid;
> >  	u8 added_by_user:1,
> >  	   is_local:1,
> > -	   offloaded:1;
> > +	   offloaded:1,
> > +	   locked:1;
> >  };
> >  
> >  struct switchdev_notifier_port_obj_info {
> > diff --git a/net/bridge/br.c b/net/bridge/br.c
> > index b1dea3febeea..adcdbecbc218 100644
> > --- a/net/bridge/br.c
> > +++ b/net/bridge/br.c
> > @@ -166,7 +166,8 @@ static int br_switchdev_event(struct notifier_block *unused,
> >  	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
> >  		fdb_info = ptr;
> >  		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
> > -						fdb_info->vid, false);
> > +						fdb_info->vid, false,
> > +						fdb_info->locked);
> >  		if (err) {
> >  			err = notifier_from_errno(err);
> >  			break;
> > diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> > index 57ec559a85a7..57aa1955d34d 100644
> > --- a/net/bridge/br_fdb.c
> > +++ b/net/bridge/br_fdb.c
> > @@ -987,7 +987,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
> >  					   "FDB entry towards bridge must be permanent");
> >  			return -EINVAL;
> >  		}
> > -		err = br_fdb_external_learn_add(br, p, addr, vid, true);
> > +		err = br_fdb_external_learn_add(br, p, addr, vid, true,
> >  false);
> 
> Does someone have an idea why there at this point is no option to add a
> dynamic fdb entry?
> 
> The fdb added entries here do not age out, while the ATU entries do
> (after 5 min), resulting in unsynced ATU vs fdb.

I think the expectation is to use br_fdb_external_learn_del() if the
externally learned entry expires. The bridge should not age by itself
FDB entries learned externally.

> >  	} else {
> >  		spin_lock_bh(&br->hash_lock);
> >  		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
> > @@ -1216,7 +1216,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
> >  
> >  int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
> >  			      const unsigned char *addr, u16 vid,
> > -			      bool swdev_notify)
> > +			      bool swdev_notify, bool locked)
> >  {
> >  	struct net_bridge_fdb_entry *fdb;
> >  	bool modified = false;
> > @@ -1236,6 +1236,9 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
> >  		if (!p)
> >  			flags |= BIT(BR_FDB_LOCAL);
> >  
> > +		if (locked)
> > +			flags |= BIT(BR_FDB_ENTRY_LOCKED);
> > +
> >  		fdb = fdb_create(br, p, addr, vid, flags);
> >  		if (!fdb) {
> >  			err = -ENOMEM;
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index f5a0b68c4857..3275e33b112f 100644
> > --- a/net/bridge/br_private.h
> > +++ b/net/bridge/br_private.h
> > @@ -790,7 +790,7 @@ int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
> >  void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
> >  int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
> >  			      const unsigned char *addr, u16 vid,
> > -			      bool swdev_notify);
> > +			      bool swdev_notify, bool locked);
> >  int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
> >  			      const unsigned char *addr, u16 vid,
> >  			      bool swdev_notify);
> > -- 
> > 2.30.2
