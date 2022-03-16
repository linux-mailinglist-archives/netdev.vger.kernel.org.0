Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F394DB838
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347147AbiCPSy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238326AbiCPSy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:54:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B4D717A9D
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 11:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647456790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0UkgVf9ICm3QHL2qUIDZ+alXDhaWQUeB7nnMENXSI6w=;
        b=M9f2PYtBuSjpQ3kLsRHh3f8zeH7VICPJjnII652W8JBHym3k9+jE+4maThVev9fMBa3/db
        vDbruVIHSiVCPPRlqbzlgoporoR7pQy9oBSx1ywf/CbkrRmM5L3wx4afnjmCKDADhEdrGK
        JHRsux4uuYRDSMYSlhhHNRzpOej/Y08=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-8gx9Yp-ROhmeo9BgG2ssOQ-1; Wed, 16 Mar 2022 14:53:09 -0400
X-MC-Unique: 8gx9Yp-ROhmeo9BgG2ssOQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2967811E9B;
        Wed, 16 Mar 2022 18:53:08 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.195.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE230434821;
        Wed, 16 Mar 2022 18:53:07 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2-next 0/2] ss: remove implicit dependency on rpcinfo
Date:   Wed, 16 Mar 2022 19:52:12 +0100
Message-Id: <cover.1647455133.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ss uses rpcinfo to get info about rpc service sockets. However, rpcinfo
is not part of iproute2 and it's an implicit dependency for ss.

This series uses libtirpc[1] API to implement the same feature of
rpcinfo for ss. This makes it possible to get info about rpc sockets,
provided ss is compiled with libtirpc support.

As a nice byproduct, this makes ss provide info about some ipv6 rpc
sockets that are not displayed using 'rpcinfo -p'.

- patch 1 adds a configure function to check for libtirpc;
- patch 2 actually rework ss to use libtirpc.

[1] https://git.linux-nfs.org/?p=steved/libtirpc.git

Andrea Claudi (2):
  configure: add check_libtirpc()
  ss: remove an implicit dependency on rpcinfo

 configure | 16 ++++++++++
 misc/ss.c | 93 +++++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 89 insertions(+), 20 deletions(-)

-- 
2.35.1

