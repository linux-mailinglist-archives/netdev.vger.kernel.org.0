Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667996EF018
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbjDZITO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjDZITM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:19:12 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Apr 2023 01:19:11 PDT
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F26710F6
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 01:19:11 -0700 (PDT)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id 17b43152;
        Wed, 26 Apr 2023 08:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=
        message-id:date:mime-version:to:from:cc:subject:content-type
        :content-transfer-encoding; s=default; bh=SjuUJfDmBIaVqCRtNKwV1b
        utnZg=; b=AP5yBqXlocAGNzdIKv3IDHqaZrD3tqKGZE49AdoSC6DuOoSs7UrDEd
        aVSpZMA4OBZXlO5pXjROX5eNuyUo+zxxDIESl9eZbESGY0Duz4FmC0mLFX9t8xhZ
        iv/Ub+6ZQ3zZGvEcp3McrkDFtQwANOm9cOi0Pl2DMsqBDNZITwXG4=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=
        message-id:date:mime-version:to:from:cc:subject:content-type
        :content-transfer-encoding; q=dns; s=default; b=h0D5aIlqEabEZWJH
        yB2jWsFWj1ywr4wTAvtfVzeMqvBWCCqM8I4M3o+LJnl8fJ5IGhdaeH+CC56X067q
        tAp4XaBMzhyO3MhnvcrXm7nKKkdaWA++6gh1FxSibxUVQosn9/N6gxCMiD+pYBSQ
        B+Fyiw81HkfWuJs4J1ALACQoU/U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1682496749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JKe4tXyTN4LWfda3y8ozIdXsCSnqcmiCZCm42rlAfHI=;
        b=f49MWkRYOkQ60nExESEm/HzPr/7sbW0nlcnZj79wp/4ESpMJL6/HYiOEVFOPAokWChK5p1
        KtwfZNNqUmvb+WWXPSAmgGnJEkKRBFH9Q3POWBQd7tQtxK6SD0bCGr4HErNPeLcjpw59J4
        ZQde3nbSy242Zif0xNgORgVilppfVLY=
Received: from [192.168.0.2] (host-79-40-239-218.business.telecomitalia.it [79.40.239.218])
        by ziongate (OpenSMTPD) with ESMTPSA id 8a6d08b1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 26 Apr 2023 08:12:29 +0000 (UTC)
Message-ID: <1c798e9d-9a48-0671-b602-613cde9585cc@kernel-space.org>
Date:   Wed, 26 Apr 2023 10:12:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To:     netdev@vger.kernel.org
From:   Angelo Dureghello <angelo@kernel-space.org>
Content-Language: en-US
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Subject: dsa: mv88e6xxx: mv88e6321 rsvd2cpu
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

working on some rstp stuff at userspace level, (kernel stp
disabled), i have seen bpdu packets was forwarded over bridge
ports generating chaos and loops. As far as i know, 802.1d asks
bpdus are not forwarded.

Finally found a solution, adding mv88e6185_g2_mgmt_rsvd2cpu()
for mv88e6321.
Is it a proper solution ? Is there any specific reason why
rsvd2cpu was not implemented for my 6321 ?
I can send the patch i am using actually. in case.

Thanks a lot.

Regards,
-- 
angelo dureghello
