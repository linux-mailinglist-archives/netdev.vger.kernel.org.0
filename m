Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C25E461FA2
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 19:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380020AbhK2SzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 13:55:25 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:38834
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380211AbhK2SxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 13:53:24 -0500
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 78E3340742
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1638211804;
        bh=NK/rX3/d5TLwtb4A4t/Shcc3utk250IIMwP05/Yxg14=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=XGJODXZRCUE6Ps3gyXhEDUUfKnuTX6sU9jl6hpousn1Lf7SMO+jzG1NNOpuSBw8/G
         wzcEqQS+rF5AnKF5R7KNlQGnpgE+zGwvMHS3gycFoMAQKN9Sl31A/1P1QL6sy6/nwk
         lmkp70FK8z5e1VVRZYbi2SMJsPaxkj5mje5iNV1OVbKIK9jWKazYOYzkP3ypSeV6Pp
         FnCxcUp6303g+3GecwX3TSgUc9OQBEuddBJ6NjJ8VWRA6x+4++BNfGSE2nvpESRrBp
         NndjSYN3QTZ88Ca88DehSuAqEENdOZKdXkotGrlx6O+5YjGeaK6sz4OuM4pxhWEAU7
         OxaW7zUpJjJTw==
Received: by mail-pf1-f200.google.com with SMTP id l7-20020a622507000000b00494608c84a4so11295504pfl.6
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 10:50:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=NK/rX3/d5TLwtb4A4t/Shcc3utk250IIMwP05/Yxg14=;
        b=BAt4aGdbV5878Pslv1TpqizyFqANkh2s/yO/hrnPiNpZauy3urAKYHgf411VyLAZUY
         3R9XoWqa2+8OTWlrl3Fp2OCBP/dI3c0gLm0B7sr4FqBsI6JtKNKGGs2mwPTbxQ2VKiaH
         e8roaX+tDK7AmvBOlp+BpwHR1ttcyX2z92qXWqAZIOLXCKwWQptzZOZ7Vz6kpkO3Coi8
         GU3+L6j6kzO67DP0uyjTG6wJ8501PjF1NgaZNdPnYhRTYYxbGO3Xee2aRWAHbpXweX9M
         sbYtyFheChhbNAzpgZUAWmEi3qiu6/ShiEbDb979qtzap3XeVJFDUCVg6kcUvXikvR05
         K9+g==
X-Gm-Message-State: AOAM530bN5XtJi5EY4KNYkTjkTimF6Qbz/SmpINbxT8SaO4bI0QxGh/O
        JJ5dqkCdH53kq8mxH/PrQ5ymO8QQVFnHG0871AJMnxAX25sTxfAGT5LKI4x3DVP9UudsiB1/V8s
        Ke6zq0JhgOhtvWBMnw4Y7u6/AaoAO2JnXNw==
X-Received: by 2002:a05:6a00:1894:b0:4a4:f2fd:d7b8 with SMTP id x20-20020a056a00189400b004a4f2fdd7b8mr41306264pfh.9.1638211802807;
        Mon, 29 Nov 2021 10:50:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGtOpGs/r6LN2bq1Ovh/3bHQ4jeMJ1jzqptWoiU0hQ5kTrZUN7LePkaz0DDeI2t4ySwILDjQ==
X-Received: by 2002:a05:6a00:1894:b0:4a4:f2fd:d7b8 with SMTP id x20-20020a056a00189400b004a4f2fdd7b8mr41306234pfh.9.1638211802480;
        Mon, 29 Nov 2021 10:50:02 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id j2sm12205721pgl.73.2021.11.29.10.50.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Nov 2021 10:50:02 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 8DF9C5FDEE; Mon, 29 Nov 2021 10:50:01 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 85CDEA0B1D;
        Mon, 29 Nov 2021 10:50:01 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv3 net-next] Bonding: add arp_missed_max option
In-reply-to: <20211123101854.1366731-1-liuhangbin@gmail.com>
References: <20211123101854.1366731-1-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Tue, 23 Nov 2021 18:18:53 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17185.1638211801.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 29 Nov 2021 10:50:01 -0800
Message-ID: <17186.1638211801@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>Currently, we use hard code number to verify if we are in the
>arp_interval timeslice. But some user may want to reduce/extend
>the verify timeslice. With the similar team option 'missed_max'
>the uers could change that number based on their own environment.
>
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>
>---
>v2: set IFLA_BOND_MISSED_MAX to NLA_U8, and limit the values to 1-255
>v3: rename the option name to arp_missed_max
>---
> Documentation/networking/bonding.rst | 10 ++++++++++
> drivers/net/bonding/bond_main.c      | 17 +++++++++--------
> drivers/net/bonding/bond_netlink.c   | 15 +++++++++++++++
> drivers/net/bonding/bond_options.c   | 28 ++++++++++++++++++++++++++++
> drivers/net/bonding/bond_procfs.c    |  2 ++
> drivers/net/bonding/bond_sysfs.c     | 13 +++++++++++++
> include/net/bond_options.h           |  1 +
> include/net/bonding.h                |  1 +
> include/uapi/linux/if_link.h         |  1 +
> tools/include/uapi/linux/if_link.h   |  1 +
> 10 files changed, 81 insertions(+), 8 deletions(-)
>
>diff --git a/Documentation/networking/bonding.rst b/Documentation/network=
ing/bonding.rst
>index 31cfd7d674a6..dc28c9551b9b 100644
>--- a/Documentation/networking/bonding.rst
>+++ b/Documentation/networking/bonding.rst
>@@ -421,6 +421,16 @@ arp_all_targets
> 		consider the slave up only when all of the arp_ip_targets
> 		are reachable
> =

>+arp_missed_max
>+
>+	Maximum number of arp_interval monitor cycle for missed ARP replies.
>+	If this number is exceeded, link is reported as down.
>+
>+	Normally 2 monitor cycles are needed. One cycle for missed ARP request
>+	and one cycle for waiting ARP reply.
>+
>+	The valid range is 1 - 255; the default value is 2.
>+

	[ Apologies for the delay in responding, I was out for the US
holiday last week. ]

	For the documentation here, since deleted code commentary from
many years ago came up in discussion (re: backup interfaces get one more
cycle), I'd suggest we rewrite the above as:

arp_missed_max

	Specifies the number of arp_interval monitor checks that must
	fail in order for an interface to be marked down by the ARP
	monitor.

	In order to provide orderly failover semantics, backup
	interfaces are permitted an extra monitor check (i.e., they must
	fail arp_missed_max + 1 times before being marked down).

	The default value is 2, and the allowable range is 1 - 255.
	=


	With the above caveat,

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J


> downdelay
> =

> 	Specifies the time, in milliseconds, to wait before disabling
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index ff8da720a33a..9a28d3de798e 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3129,8 +3129,8 @@ static void bond_loadbalance_arp_mon(struct bonding=
 *bond)
> 			 * when the source ip is 0, so don't take the link down
> 			 * if we don't know our ip yet
> 			 */
>-			if (!bond_time_in_interval(bond, trans_start, 2) ||
>-			    !bond_time_in_interval(bond, slave->last_rx, 2)) {
>+			if (!bond_time_in_interval(bond, trans_start, bond->params.missed_max=
) ||
>+			    !bond_time_in_interval(bond, slave->last_rx, bond->params.missed_=
max)) {
> =

> 				bond_propose_link_state(slave, BOND_LINK_DOWN);
> 				slave_state_changed =3D 1;
>@@ -3224,7 +3224,7 @@ static int bond_ab_arp_inspect(struct bonding *bond=
)
> =

> 		/* Backup slave is down if:
> 		 * - No current_arp_slave AND
>-		 * - more than 3*delta since last receive AND
>+		 * - more than (missed_max+1)*delta since last receive AND
> 		 * - the bond has an IP address
> 		 *
> 		 * Note: a non-null current_arp_slave indicates
>@@ -3236,20 +3236,20 @@ static int bond_ab_arp_inspect(struct bonding *bo=
nd)
> 		 */
> 		if (!bond_is_active_slave(slave) &&
> 		    !rcu_access_pointer(bond->current_arp_slave) &&
>-		    !bond_time_in_interval(bond, last_rx, 3)) {
>+		    !bond_time_in_interval(bond, last_rx, bond->params.missed_max+1)) =
{
> 			bond_propose_link_state(slave, BOND_LINK_DOWN);
> 			commit++;
> 		}
> =

> 		/* Active slave is down if:
>-		 * - more than 2*delta since transmitting OR
>-		 * - (more than 2*delta since receive AND
>+		 * - more than missed_max*delta since transmitting OR
>+		 * - (more than missed_max*delta since receive AND
> 		 *    the bond has an IP address)
> 		 */
> 		trans_start =3D dev_trans_start(slave->dev);
> 		if (bond_is_active_slave(slave) &&
>-		    (!bond_time_in_interval(bond, trans_start, 2) ||
>-		     !bond_time_in_interval(bond, last_rx, 2))) {
>+		    (!bond_time_in_interval(bond, trans_start, bond->params.missed_max=
) ||
>+		     !bond_time_in_interval(bond, last_rx, bond->params.missed_max))) =
{
> 			bond_propose_link_state(slave, BOND_LINK_DOWN);
> 			commit++;
> 		}
>@@ -5822,6 +5822,7 @@ static int bond_check_params(struct bond_params *pa=
rams)
> 	params->arp_interval =3D arp_interval;
> 	params->arp_validate =3D arp_validate_value;
> 	params->arp_all_targets =3D arp_all_targets_value;
>+	params->missed_max =3D 2;
> 	params->updelay =3D updelay;
> 	params->downdelay =3D downdelay;
> 	params->peer_notif_delay =3D 0;
>diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bon=
d_netlink.c
>index 5d54e11d18fa..1007bf6d385d 100644
>--- a/drivers/net/bonding/bond_netlink.c
>+++ b/drivers/net/bonding/bond_netlink.c
>@@ -110,6 +110,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_=
MAX + 1] =3D {
> 					    .len  =3D ETH_ALEN },
> 	[IFLA_BOND_TLB_DYNAMIC_LB]	=3D { .type =3D NLA_U8 },
> 	[IFLA_BOND_PEER_NOTIF_DELAY]    =3D { .type =3D NLA_U32 },
>+	[IFLA_BOND_MISSED_MAX]		=3D { .type =3D NLA_U8 },
> };
> =

> static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1=
] =3D {
>@@ -453,6 +454,15 @@ static int bond_changelink(struct net_device *bond_d=
ev, struct nlattr *tb[],
> 			return err;
> 	}
> =

>+	if (data[IFLA_BOND_MISSED_MAX]) {
>+		int missed_max =3D nla_get_u8(data[IFLA_BOND_MISSED_MAX]);
>+
>+		bond_opt_initval(&newval, missed_max);
>+		err =3D __bond_opt_set(bond, BOND_OPT_MISSED_MAX, &newval);
>+		if (err)
>+			return err;
>+	}
>+
> 	return 0;
> }
> =

>@@ -515,6 +525,7 @@ static size_t bond_get_size(const struct net_device *=
bond_dev)
> 		nla_total_size(ETH_ALEN) + /* IFLA_BOND_AD_ACTOR_SYSTEM */
> 		nla_total_size(sizeof(u8)) + /* IFLA_BOND_TLB_DYNAMIC_LB */
> 		nla_total_size(sizeof(u32)) +	/* IFLA_BOND_PEER_NOTIF_DELAY */
>+		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_MISSED_MAX */
> 		0;
> }
> =

>@@ -650,6 +661,10 @@ static int bond_fill_info(struct sk_buff *skb,
> 		       bond->params.tlb_dynamic_lb))
> 		goto nla_put_failure;
> =

>+	if (nla_put_u8(skb, IFLA_BOND_MISSED_MAX,
>+		       bond->params.missed_max))
>+		goto nla_put_failure;
>+
> 	if (BOND_MODE(bond) =3D=3D BOND_MODE_8023AD) {
> 		struct ad_info info;
> =

>diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bon=
d_options.c
>index a8fde3bc458f..0f48921c4f15 100644
>--- a/drivers/net/bonding/bond_options.c
>+++ b/drivers/net/bonding/bond_options.c
>@@ -78,6 +78,8 @@ static int bond_option_ad_actor_system_set(struct bondi=
ng *bond,
> 					   const struct bond_opt_value *newval);
> static int bond_option_ad_user_port_key_set(struct bonding *bond,
> 					    const struct bond_opt_value *newval);
>+static int bond_option_missed_max_set(struct bonding *bond,
>+				      const struct bond_opt_value *newval);
> =

> =

> static const struct bond_opt_value bond_mode_tbl[] =3D {
>@@ -213,6 +215,13 @@ static const struct bond_opt_value bond_ad_user_port=
_key_tbl[] =3D {
> 	{ NULL,      -1,    0},
> };
> =

>+static const struct bond_opt_value bond_missed_max_tbl[] =3D {
>+	{ "minval",	1,	BOND_VALFLAG_MIN},
>+	{ "maxval",	255,	BOND_VALFLAG_MAX},
>+	{ "default",	2,	BOND_VALFLAG_DEFAULT},
>+	{ NULL,		-1,	0},
>+};
>+
> static const struct bond_option bond_opts[BOND_OPT_LAST] =3D {
> 	[BOND_OPT_MODE] =3D {
> 		.id =3D BOND_OPT_MODE,
>@@ -270,6 +279,15 @@ static const struct bond_option bond_opts[BOND_OPT_L=
AST] =3D {
> 		.values =3D bond_intmax_tbl,
> 		.set =3D bond_option_arp_interval_set
> 	},
>+	[BOND_OPT_MISSED_MAX] =3D {
>+		.id =3D BOND_OPT_MISSED_MAX,
>+		.name =3D "arp_missed_max",
>+		.desc =3D "Maximum number of missed ARP interval",
>+		.unsuppmodes =3D BIT(BOND_MODE_8023AD) | BIT(BOND_MODE_TLB) |
>+			       BIT(BOND_MODE_ALB),
>+		.values =3D bond_missed_max_tbl,
>+		.set =3D bond_option_missed_max_set
>+	},
> 	[BOND_OPT_ARP_TARGETS] =3D {
> 		.id =3D BOND_OPT_ARP_TARGETS,
> 		.name =3D "arp_ip_target",
>@@ -1186,6 +1204,16 @@ static int bond_option_arp_all_targets_set(struct =
bonding *bond,
> 	return 0;
> }
> =

>+static int bond_option_missed_max_set(struct bonding *bond,
>+				      const struct bond_opt_value *newval)
>+{
>+	netdev_dbg(bond->dev, "Setting missed max to %s (%llu)\n",
>+		   newval->string, newval->value);
>+	bond->params.missed_max =3D newval->value;
>+
>+	return 0;
>+}
>+
> static int bond_option_primary_set(struct bonding *bond,
> 				   const struct bond_opt_value *newval)
> {
>diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond=
_procfs.c
>index f3e3bfd72556..2ec11af5f0cc 100644
>--- a/drivers/net/bonding/bond_procfs.c
>+++ b/drivers/net/bonding/bond_procfs.c
>@@ -115,6 +115,8 @@ static void bond_info_show_master(struct seq_file *se=
q)
> =

> 		seq_printf(seq, "ARP Polling Interval (ms): %d\n",
> 				bond->params.arp_interval);
>+		seq_printf(seq, "ARP Missed Max: %u\n",
>+				bond->params.missed_max);
> =

> 		seq_printf(seq, "ARP IP target/s (n.n.n.n form):");
> =

>diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_=
sysfs.c
>index c48b77167fab..9b5a5df23d21 100644
>--- a/drivers/net/bonding/bond_sysfs.c
>+++ b/drivers/net/bonding/bond_sysfs.c
>@@ -303,6 +303,18 @@ static ssize_t bonding_show_arp_targets(struct devic=
e *d,
> static DEVICE_ATTR(arp_ip_target, 0644,
> 		   bonding_show_arp_targets, bonding_sysfs_store_option);
> =

>+/* Show the arp missed max. */
>+static ssize_t bonding_show_missed_max(struct device *d,
>+				       struct device_attribute *attr,
>+				       char *buf)
>+{
>+	struct bonding *bond =3D to_bond(d);
>+
>+	return sprintf(buf, "%u\n", bond->params.missed_max);
>+}
>+static DEVICE_ATTR(arp_missed_max, 0644,
>+		   bonding_show_missed_max, bonding_sysfs_store_option);
>+
> /* Show the up and down delays. */
> static ssize_t bonding_show_downdelay(struct device *d,
> 				      struct device_attribute *attr,
>@@ -779,6 +791,7 @@ static struct attribute *per_bond_attrs[] =3D {
> 	&dev_attr_ad_actor_sys_prio.attr,
> 	&dev_attr_ad_actor_system.attr,
> 	&dev_attr_ad_user_port_key.attr,
>+	&dev_attr_arp_missed_max.attr,
> 	NULL,
> };
> =

>diff --git a/include/net/bond_options.h b/include/net/bond_options.h
>index e64833a674eb..dd75c071f67e 100644
>--- a/include/net/bond_options.h
>+++ b/include/net/bond_options.h
>@@ -65,6 +65,7 @@ enum {
> 	BOND_OPT_NUM_PEER_NOTIF_ALIAS,
> 	BOND_OPT_PEER_NOTIF_DELAY,
> 	BOND_OPT_LACP_ACTIVE,
>+	BOND_OPT_MISSED_MAX,
> 	BOND_OPT_LAST
> };
> =

>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index 15e083e18f75..f6ae3a4baea4 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -121,6 +121,7 @@ struct bond_params {
> 	int xmit_policy;
> 	int miimon;
> 	u8 num_peer_notif;
>+	u8 missed_max;
> 	int arp_interval;
> 	int arp_validate;
> 	int arp_all_targets;
>diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>index eebd3894fe89..4ac53b30b6dc 100644
>--- a/include/uapi/linux/if_link.h
>+++ b/include/uapi/linux/if_link.h
>@@ -858,6 +858,7 @@ enum {
> 	IFLA_BOND_TLB_DYNAMIC_LB,
> 	IFLA_BOND_PEER_NOTIF_DELAY,
> 	IFLA_BOND_AD_LACP_ACTIVE,
>+	IFLA_BOND_MISSED_MAX,
> 	__IFLA_BOND_MAX,
> };
> =

>diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linu=
x/if_link.h
>index b3610fdd1fee..4772a115231a 100644
>--- a/tools/include/uapi/linux/if_link.h
>+++ b/tools/include/uapi/linux/if_link.h
>@@ -655,6 +655,7 @@ enum {
> 	IFLA_BOND_TLB_DYNAMIC_LB,
> 	IFLA_BOND_PEER_NOTIF_DELAY,
> 	IFLA_BOND_AD_LACP_ACTIVE,
>+	IFLA_BOND_MISSED_MAX,
> 	__IFLA_BOND_MAX,
> };
> =

>-- =

>2.31.1
>
