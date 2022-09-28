Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7545EE1A7
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbiI1QSv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 12:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiI1QSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:18:08 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDC110553
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:18:06 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-3HWkgXTFOA2bEfBc7Qx7ug-1; Wed, 28 Sep 2022 12:18:01 -0400
X-MC-Unique: 3HWkgXTFOA2bEfBc7Qx7ug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF10C800D89;
        Wed, 28 Sep 2022 16:17:39 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 492289D464;
        Wed, 28 Sep 2022 16:17:38 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 00/12] macsec: replace custom netlink attribute checks with policy-level checks
Date:   Wed, 28 Sep 2022 18:17:13 +0200
Message-Id: <cover.1664379352.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can simplify attribute validation a lot by describing the accepted
ranges more precisely in the policies, using NLA_POLICY_MAX etc.

Some of the checks still need to be done later on, because the
attribute length and acceptable range can vary based on values that
can't be known when the policy is validated (cipher suite determines
the key length and valid ICV length, presence of XPN changes the PN
length, detection of duplicate SCIs or ANs, etc).

As a bonus, we get a few extack messages from the policy
validation. I'll add extack to the rest of the checks (mostly in the
genl commands) in an future series.

Sabrina Dubroca (12):
  macsec: replace custom checks on MACSEC_SA_ATTR_AN with NLA_POLICY_MAX
  macsec: replace custom checks on MACSEC_*_ATTR_ACTIVE with
    NLA_POLICY_MAX
  macsec: replace custom checks on MACSEC_SA_ATTR_SALT with
    NLA_POLICY_EXACT_LEN
  macsec: replace custom checks on MACSEC_SA_ATTR_KEYID with
    NLA_POLICY_EXACT_LEN
  macsec: use NLA_POLICY_VALIDATE_FN to validate MACSEC_SA_ATTR_PN
  macsec: add NLA_POLICY_MAX for MACSEC_OFFLOAD_ATTR_TYPE and
    IFLA_MACSEC_OFFLOAD
  macsec: replace custom checks on IFLA_MACSEC_ICV_LEN with
    NLA_POLICY_RANGE
  macsec: use NLA_POLICY_VALIDATE_FN to validate
    IFLA_MACSEC_CIPHER_SUITE
  macsec: validate IFLA_MACSEC_VALIDATION with NLA_POLICY_MAX
  macsec: replace custom checks for IFLA_MACSEC_* flags with
    NLA_POLICY_MAX
  macsec: replace custom check on IFLA_MACSEC_ENCODING_SA with
    NLA_POLICY_MAX
  macsec: remove validate_add_rxsc

 drivers/net/macsec.c | 178 ++++++++++++-------------------------------
 1 file changed, 50 insertions(+), 128 deletions(-)

-- 
2.37.3

