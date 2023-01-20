Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81018675AB0
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjATRC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjATRC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:02:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55D44ABEC
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 09:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674234122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bixlKFajuFSCm4moj8W/iRIzzqUkOwnKVEiWQwEKwj4=;
        b=dUpureDQtxnnylnvv4h/r75lMWDjYlNm62y1GTvd6UmkuHo3XESZAnd0wTMAmRWU/HqgDY
        h0HtaqzsHuU2pbCqKIsd22zVsSKOd10QEsBE09zwv3O3bwoZXJA1NhVf8YcdFt9dnSTQ1G
        cUQTE+lExP+Yv40kZBPkVbxuIxQBdaQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-tqa8IWJENZe487jGdaek5w-1; Fri, 20 Jan 2023 12:01:58 -0500
X-MC-Unique: tqa8IWJENZe487jGdaek5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 759B83814580;
        Fri, 20 Jan 2023 17:01:58 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (ovpn-194-73.brq.redhat.com [10.40.194.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 312A92166B2A;
        Fri, 20 Jan 2023 17:01:54 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     jhs@mojatatu.com
Cc:     jiri@resnulli.us, lucien.xin@gmail.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com, wizhao@redhat.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH net-next 0/2] net/sched: use the backlog for nested mirred ingress
Date:   Fri, 20 Jan 2023 18:01:38 +0100
Message-Id: <cover.1674233458.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TC mirred has a protection against excessive stack growth, but that
protection doesn't really guarantee the absence of recursion, nor
it guards against loops. Patch 1/2 rewords "recursion" to "nesting" to
make this more clear.
We can leverage on this existing mechanism to prevent TCP / SCTP from doing
soft lock-up in some specific scenarios that uses mirred egress->ingress:
patch 2 changes mirred so that the networking backlog is used for nested
mirred ingress actions.


Davide Caratti (2):
  net/sched: act_mirred: better wording on protection against excessive
    stack growth
  act_mirred: use the backlog for nested calls to mirred ingress

 net/sched/act_mirred.c                        | 23 ++++++---
 .../selftests/net/forwarding/tc_actions.sh    | 49 ++++++++++++++++++-
 2 files changed, 63 insertions(+), 9 deletions(-)

-- 
2.38.1

