Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38B96374DE
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiKXJMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKXJMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:12:19 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77751D306
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:12:18 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id v8so1704734edi.3
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y/eBErA5WpUsOqpgtQRiHfjF8VBSc5TbR98tLfV9pUE=;
        b=CeV1Bgzq4SkFVfcpa/Qj/E/WSN9ifmDGc5QIxfKE2ewZT3PRbS1Ok3palGF6XThZVi
         WgvdALbntLoqO1shOtBt+AFEuvZwFTxCeGWOJwmsR8qOuBizyhdURw81ltr3VLiKNOpP
         pYS/uRRKukHlFiczv5FzprTRAlnU110Ea0UylaJTjL/0qvYNuRjmqYigK6OjTDeDFgJO
         FxYVYXGcckLtR0lZmwHtuLCrOChZjbcqDxIFBeCbJ/L5co67M0gobIp5iVuGxcOHob6Y
         QaUv4xewMn3vVlfBSv0/aZmIyzyI1kuk7pS96krW1vgTS3IAs4yp8zAhtVazMgflVh+r
         JF8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y/eBErA5WpUsOqpgtQRiHfjF8VBSc5TbR98tLfV9pUE=;
        b=nqT9umg+7cvdOtgzxmYVerUBqhmLVPrK8q7MRH3B+c+ycFpm16ld3eWHP8srR/XMwk
         7HszXYc1PZDx5vfNMZGYIE5mB4W1ttm/BNIje8zMG5LG/Opx4aZF+aM5hF2+G3Yw47w6
         1Go/DNBB7dcLeXseTJm98NqY6AmMHVHb033ritMayTA7YS8FV7X6i54BMgwl8BDVifrH
         +uSIqJtxHCakAXyyx3TcMhniwA/WEj9xM09TIRESkJmBhhLLDGir8U5ZCjqzhyT/epW0
         9xgoXgfDE+A4JrwiT736OtPhgb9bGuSwKv/QHt3GW0QbfGzNB9ff6F64HlTqbvN9YzRz
         YhNA==
X-Gm-Message-State: ANoB5pnWQQ1RGyK7nZG+sD1C5lkvyOXqDYgl2p0EKMLb551dFBo2c0ek
        Lm3YgdumZNRIVO+dcT8ZrgBMwQ==
X-Google-Smtp-Source: AA0mqf6ITWvx6muuRGsbmX1txy32ymy8+cqzglc8mMKXz971nDuogM6Jk3E9D7KZqBMsPOK2cqHrVQ==
X-Received: by 2002:aa7:cd99:0:b0:462:719:3372 with SMTP id x25-20020aa7cd99000000b0046207193372mr29540871edv.361.1669281137286;
        Thu, 24 Nov 2022 01:12:17 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u1-20020a1709061da100b007b7ae09683bsm212127ejh.95.2022.11.24.01.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 01:12:16 -0800 (PST)
Date:   Thu, 24 Nov 2022 10:12:15 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 5/9] devlink: refactor
 region_read_snapshot_fill to use a callback function
Message-ID: <Y381byfh6Oz6xKBD@nanopsycho>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
 <20221123203834.738606-6-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123203834.738606-6-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 23, 2022 at 09:38:30PM CET, jacob.e.keller@intel.com wrote:
>The devlink_nl_region_read_snapshot_fill is used to copy the contents of
>a snapshot into a message for reporting to userspace via the
>DEVLINK_CMG_REGION_READ netlink message.
>
>A future change is going to add support for directly reading from
>a region. Almost all of the logic for this new capability is identical.
>
>To help reduce code duplication and make this logic more generic,
>refactor the function to take a cb and cb_priv pointer for doing the
>actual copy.
>
>Add a devlink_region_snapshot_fill implementation that will simply copy
>the relevant chunk of the region. This does require allocating some
>storage for the chunk as opposed to simply passing the correct address
>forward to the devlink_nl_cmg_region_read_chunk_fill function.
>
>A future change to implement support for directly reading from a region
>without a snapshot will provide a separate implementation that calls the
>newly added devlink region operation.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
>Changes since v1:
>* Use kmalloc instead of kzalloc
>* Don't combine data_size declaration and assignment
>* Fix the always_unused placement for devlink_region_snapshot_fill
>
> net/core/devlink.c | 44 +++++++++++++++++++++++++++++++++++---------
> 1 file changed, 35 insertions(+), 9 deletions(-)
>
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index bd7af0600405..729e2162a4db 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -6460,25 +6460,36 @@ static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
> 
> #define DEVLINK_REGION_READ_CHUNK_SIZE 256
> 
>-static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
>-						struct devlink_snapshot *snapshot,
>-						u64 start_offset,
>-						u64 end_offset,
>-						u64 *new_offset)
>+typedef int devlink_chunk_fill_t(void *cb_priv, u8 *chunk, u32 chunk_size,
>+				 u64 curr_offset,
>+				 struct netlink_ext_ack *extack);
>+
>+static int
>+devlink_nl_region_read_fill(struct sk_buff *skb, devlink_chunk_fill_t *cb,
>+			    void *cb_priv, u64 start_offset, u64 end_offset,
>+			    u64 *new_offset, struct netlink_ext_ack *extack)
> {
> 	u64 curr_offset = start_offset;
> 	int err = 0;
>+	u8 *data;
>+
>+	/* Allocate and re-use a single buffer */
>+	data = kmalloc(DEVLINK_REGION_READ_CHUNK_SIZE, GFP_KERNEL);

Hmm, I tried to figure out how to do this without extra alloc and
memcpy, didn't find any nice solution :/

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Btw, do you plan to extend this for write as well. It might be valuable
for debugging purposes to have that. I recall we discussed it in past.



>+	if (!data)
>+		return -ENOMEM;
> 
> 	*new_offset = start_offset;
> 
> 	while (curr_offset < end_offset) {
> 		u32 data_size;
>-		u8 *data;
> 
> 		data_size = min_t(u32, end_offset - curr_offset,
> 				  DEVLINK_REGION_READ_CHUNK_SIZE);
> 
>-		data = &snapshot->data[curr_offset];
>+		err = cb(cb_priv, data, data_size, curr_offset, extack);
>+		if (err)
>+			break;
>+
> 		err = devlink_nl_cmd_region_read_chunk_fill(skb, data, data_size, curr_offset);
> 		if (err)
> 			break;
>@@ -6487,9 +6498,23 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
> 	}
> 	*new_offset = curr_offset;
> 
>+	kfree(data);
>+
> 	return err;
> }
> 
>+static int
>+devlink_region_snapshot_fill(void *cb_priv, u8 *chunk, u32 chunk_size,
>+			     u64 curr_offset,
>+			     struct netlink_ext_ack __always_unused *extack)
>+{
>+	struct devlink_snapshot *snapshot = cb_priv;
>+
>+	memcpy(chunk, &snapshot->data[curr_offset], chunk_size);
>+
>+	return 0;
>+}
>+
> static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 					     struct netlink_callback *cb)
> {
>@@ -6608,8 +6633,9 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 		goto nla_put_failure;
> 	}
> 
>-	err = devlink_nl_region_read_snapshot_fill(skb, snapshot, start_offset,
>-						   end_offset, &ret_offset);
>+	err = devlink_nl_region_read_fill(skb, &devlink_region_snapshot_fill,
>+					  snapshot, start_offset, end_offset,
>+					  &ret_offset, cb->extack);
> 
> 	if (err && err != -EMSGSIZE)
> 		goto nla_put_failure;
>-- 
>2.38.1.420.g319605f8f00e
>
