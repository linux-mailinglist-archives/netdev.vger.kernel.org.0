Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33036DCB65
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 21:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjDJTME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 15:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjDJTMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 15:12:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC241734
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 12:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681153874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=chUNGll3iD9tAjlYwwUH5JOb6AFG0zsrnWXAILdp4m0=;
        b=OUX/otYVObvTxKc5y0Te3cZwN++qFjDwPaAd+YRlOU/jypChiIigA4sLzprfdtFsa4AlDU
        R7FKqX/vit7h4IfrFulJFYu7YkJO5p1o4R6eTTqtpL8HcGUD9CGXztlVlj5CKQtuGDPmch
        6gmoJRswiJNkqPyhziocnHzka7ajf9I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-ewEqmW_xMqSYh-jwfZmg7Q-1; Mon, 10 Apr 2023 15:11:11 -0400
X-MC-Unique: ewEqmW_xMqSYh-jwfZmg7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E76C9185A794;
        Mon, 10 Apr 2023 19:11:10 +0000 (UTC)
Received: from localhost.redhat.com (unknown [10.2.16.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AC6640C20FA;
        Mon, 10 Apr 2023 19:11:10 +0000 (UTC)
From:   Chris Leech <cleech@redhat.com>
To:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        Hannes Reinecke <hare@suse.de>,
        Lee Duncan <leeman.duncan@gmail.com>, netdev@vger.kernel.org
Cc:     Chris Leech <cleech@redhat.com>
Subject: Re: [RFC PATCH 4/9] iscsi: make all iSCSI netlink multicast namespace aware
Date:   Mon, 10 Apr 2023 12:10:31 -0700
Message-Id: <20230410191033.1069293-1-cleech@redhat.com>
In-Reply-To: <83de4002-6846-2f90-7848-ef477f0b0fe5@suse.de>
References: <83de4002-6846-2f90-7848-ef477f0b0fe5@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> As discussed with Lee: you should tear down sessions related to this
> namespace from the pernet ->exit callback, otherwise you end up with
> session which can no longer been reached as the netlink socket is
> gone.

These two follow on changes handle removing active sesions when the
namespace exits. Tested with iscsi_tcp and seems to be working for me.

Chris Leech (2):
  iscsi: make session and connection lists per-net
  iscsi: force destroy sesions when a network namespace exits

 drivers/scsi/scsi_transport_iscsi.c | 122 ++++++++++++++++++----------
 1 file changed, 79 insertions(+), 43 deletions(-)

-- 
2.39.2

