Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217E21BE2D3
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgD2Pec convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Apr 2020 11:34:32 -0400
Received: from mga17.intel.com ([192.55.52.151]:2228 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbgD2Peb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 11:34:31 -0400
IronPort-SDR: FdQkVwEE4oYZGldeDUFd9/celxIU3mkD8/BdwBtXu8yuUGuPwiomO/e7d15QZxbQ7xRYLWH5pc
 eSrBo/U6680Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 08:34:31 -0700
IronPort-SDR: NJt3oBG0zuk+guq4KCCQ46ic5Pv2itu7HTgoQfxYSTyrW8IlSNbpVfg73fkEhbN6GLDWQ+JeP8
 1wr9kpH/wquA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="459236932"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga005.fm.intel.com with ESMTP; 29 Apr 2020 08:34:31 -0700
Received: from fmsmsx158.amr.corp.intel.com (10.18.116.75) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 29 Apr 2020 08:34:31 -0700
Received: from fmsmsx102.amr.corp.intel.com ([169.254.10.190]) by
 fmsmsx158.amr.corp.intel.com ([169.254.15.11]) with mapi id 14.03.0439.000;
 Wed, 29 Apr 2020 08:34:31 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: RE: [PATCH net-next] devlink: let kernel allocate region snapshot id
Thread-Topic: [PATCH net-next] devlink: let kernel allocate region snapshot
 id
Thread-Index: AQHWHceR29w0a4iV6kCQcvF+ImGWRqiQDKwAgAAr4oA=
Date:   Wed, 29 Apr 2020 15:34:30 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58B6CF7AFF@FMSMSX102.amr.corp.intel.com>
References: <20200429014248.893731-1-kuba@kernel.org>
 <20200429054552.GB6581@nanopsycho.orion>
In-Reply-To: <20200429054552.GB6581@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jiri Pirko
> Sent: Tuesday, April 28, 2020 10:46 PM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; kernel-team@fb.com;
> Keller, Jacob E <jacob.e.keller@intel.com>
> Subject: Re: [PATCH net-next] devlink: let kernel allocate region snapshot id
> 
> Wed, Apr 29, 2020 at 03:42:48AM CEST, kuba@kernel.org wrote:
> >Currently users have to choose a free snapshot id before
> >calling DEVLINK_CMD_REGION_NEW. This is potentially racy
> >and inconvenient.
> >

I did propose something like this originally, but....

> >Make the DEVLINK_ATTR_REGION_SNAPSHOT_ID optional and try
> >to allocate id automatically. Send a message back to the
> >caller with the snapshot info.
> >

... sending a message back makes this work better.

> >The message carrying id gets sent immediately, but the
> >allocation is only valid if the entire operation succeeded.
> >This makes life easier, as sending the notification itself
> >may fail.
> >

It seems like we could wait until at least after the region is captured.

> >Example use:
> >$ devlink region new netdevsim/netdevsim1/dummy
> >netdevsim/netdevsim1/dummy: snapshot 1
> >
> >$ id=$(devlink -j region new netdevsim/netdevsim1/dummy | \
> >       jq '.[][][][]')
> >$ devlink region dump netdevsim/netdevsim1/dummy snapshot $id
> >[...]
> >$ devlink region del netdevsim/netdevsim1/dummy snapshot $id
> >
> >Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >---
> >Jiri, this is what I had in mind of snapshots and the same
> >thing will come back for slice allocation.
> 
> Okay. Could you please send the userspace patch too in order to see the
> full picture?
> 

Yes, I'd like to see this as well.

> 
> >
> > net/core/devlink.c                            | 84 ++++++++++++++++---
> > .../drivers/net/netdevsim/devlink.sh          | 13 +++
> > 2 files changed, 84 insertions(+), 13 deletions(-)
> >
> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> >index 1ec2e9fd8898..dad5d07dd4f8 100644
> >--- a/net/core/devlink.c
> >+++ b/net/core/devlink.c
> >@@ -4065,10 +4065,65 @@ static int devlink_nl_cmd_region_del(struct sk_buff
> *skb,
> > 	return 0;
> > }
> >
> >+static int
> >+devlink_nl_alloc_snapshot_id(struct devlink *devlink, struct genl_info *info,
> >+			     struct devlink_region *region, u32 *snapshot_id)
> >+{
> >+	struct sk_buff *msg;
> >+	void *hdr;
> >+	int err;
> >+
> >+	err = __devlink_region_snapshot_id_get(devlink, snapshot_id);
> >+	if (err) {
> >+		NL_SET_ERR_MSG_MOD(info->extack,
> 
> No need to wrap here.
> 
> 
> >+				   "Failed to allocate a new snapshot id");
> >+		return err;
> >+	}
> >+
> >+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> >+	if (!msg) {
> >+		err = -ENOMEM;
> >+		goto err_msg_alloc;
> >+	}
> >+
> >+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
> >+			  &devlink_nl_family, 0, DEVLINK_CMD_REGION_NEW);
> >+	if (!hdr) {
> >+		err = -EMSGSIZE;
> >+		goto err_put_failure;
> >+	}
> >+	err = devlink_nl_put_handle(msg, devlink);
> >+	if (err)
> >+		goto err_attr_failure;
> >+	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME, region->ops-
> >name);
> >+	if (err)
> >+		goto err_attr_failure;
> >+	err = nla_put_u32(msg, DEVLINK_ATTR_REGION_SNAPSHOT_ID,
> *snapshot_id);
> >+	if (err)
> >+		goto err_attr_failure;
> >+	genlmsg_end(msg, hdr);
> >+
> >+	err = genlmsg_reply(msg, info);
> >+	if (err)
> >+		goto err_reply;
> >+
> >+	return 0;
> >+
> >+err_attr_failure:
> >+	genlmsg_cancel(msg, hdr);
> >+err_put_failure:
> >+	nlmsg_free(msg);
> >+err_msg_alloc:
> >+err_reply:
> >+	__devlink_snapshot_id_decrement(devlink, *snapshot_id);
> >+	return err;
> >+}
> >+
> > static int
> > devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
> > {
> > 	struct devlink *devlink = info->user_ptr[0];
> >+	struct nlattr *snapshot_id_attr;
> > 	struct devlink_region *region;
> > 	const char *region_name;
> > 	u32 snapshot_id;
> >@@ -4080,11 +4135,6 @@ devlink_nl_cmd_region_new(struct sk_buff *skb,
> struct genl_info *info)
> > 		return -EINVAL;
> > 	}
> >
> >-	if (!info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
> >-		NL_SET_ERR_MSG_MOD(info->extack, "No snapshot id
> provided");
> >-		return -EINVAL;
> >-	}
> >-
> > 	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
> > 	region = devlink_region_get_by_name(devlink, region_name);
> > 	if (!region) {
> >@@ -4102,16 +4152,24 @@ devlink_nl_cmd_region_new(struct sk_buff *skb,
> struct genl_info *info)
> > 		return -ENOSPC;
> > 	}
> >
> >-	snapshot_id = nla_get_u32(info-
> >attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
> >+	snapshot_id_attr = info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID];
> >+	if (snapshot_id_attr) {
> >+		snapshot_id = nla_get_u32(snapshot_id_attr);
> >
> >-	if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
> >-		NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot
> id is already in use");
> >-		return -EEXIST;
> >-	}
> >+		if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
> >+			NL_SET_ERR_MSG_MOD(info->extack, "The requested
> snapshot id is already in use");
> >+			return -EEXIST;
> >+		}
> >
> >-	err = __devlink_snapshot_id_insert(devlink, snapshot_id);
> >-	if (err)
> >-		return err;
> >+		err = __devlink_snapshot_id_insert(devlink, snapshot_id);
> >+		if (err)
> >+			return err;
> >+	} else {
> >+		err = devlink_nl_alloc_snapshot_id(devlink, info,
> >+						   region, &snapshot_id);
> >+		if (err)
> >+			return err;
> >+	}
> >
> > 	err = region->ops->snapshot(devlink, info->extack, &data);
> 
> How the output is going to looks like it this or any of the follow-up
> calls in this function are going to fail?
> 
> I guess it is going to be handled gracefully in the userspace app,
> right?
> 
> 

I'm wondering what the issue is with just waiting to send the snapshot id back until after this succeeds. Is it just easier to keep it near the allocation?

Thanks,
Jake
