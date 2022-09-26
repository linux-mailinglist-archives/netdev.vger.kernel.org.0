Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769805EAE69
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 19:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiIZRno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 13:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiIZRnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 13:43:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA33E7671;
        Mon, 26 Sep 2022 10:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71476B80B38;
        Mon, 26 Sep 2022 17:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FD5C433D6;
        Mon, 26 Sep 2022 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664212296;
        bh=wRzMSWNoTOa7HYB/QCA8HJnta4RDBmUeLPGo+3JzOAE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ioMVFULQz/j5Plp35zUh5EJsql/QVxUEacE5O6M177rfpeTYTLwiMZQ9zhjfDLIag
         Vwo+vcn2v2dNvFEA6Q4ASzdQiz7x0M66VO3LLJK+NQinJdH4cWeGhplVf3sLkNaQmw
         y73rN3XdnazNiVix72myaDRt1bNtqxOm9aahw3l4IdaVDckf9COqBluvfkL6p95TjZ
         1ycLUWapfUBnWEnLUiXLPXW1ME+OyWYiM/8mzAbPNcLROMFhQlkG9l4UmllIAIrmnU
         DbJKV4V6y79FA79mNyP1O3sXtkTj7elvw0UiWO7W1SKetrVylqPFu4wXg002pRrD0p
         uf6AVFQsqNUxg==
Date:   Mon, 26 Sep 2022 10:11:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     Leon Romanovsky <leon@kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <lanhao@huawei.com>
Subject: Re: [PATCH net-next 00/14] redefine some macros of feature
 abilities judgement
Message-ID: <20220926101135.26382c0c@kernel.org>
In-Reply-To: <77050062-93b5-7488-a427-815f4c631b32@huawei.com>
References: <20220924023024.14219-1-huangguangbin2@huawei.com>
        <Yy7pjTX8VLLIiA0G@unreal>
        <77050062-93b5-7488-a427-815f4c631b32@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 20:56:26 +0800 huangguangbin (A) wrote:
> On 2022/9/24 19:27, Leon Romanovsky wrote:
> > On Sat, Sep 24, 2022 at 10:30:10AM +0800, Guangbin Huang wrote:  
> >> The macros hnae3_dev_XXX_supported just can be used in hclge layer, but
> >> hns3_enet layer may need to use, so this serial redefine these macros.  
> > 
> > IMHO, you shouldn't add new obfuscated code, but delete it.
> > 
> > Jakub,
> > 
> > The more drivers authors will obfuscate in-kernel primitives and reinvent
> > their own names, macros e.t.c, the less external reviewers you will be able
> > to attract.
> > 
> > IMHO, netdev should have more active position do not allow obfuscated code.
> > 
> > Thanks
> >   
> 
> Hi, Leon
> I'm sorry, I can not get your point. Can you explain in more detail?
> Do you mean the name "macro" should not be used?

He is saying that you should try to remove those macros rather than
touch them up. The macros may seem obvious to people working on the
driver but to upstream reviewers any local conventions obfuscate the
code and require looking up definitions.

For example the first patch is better off as:

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 0179fc288f5f..449d496b824b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -107,9 +107,6 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_gro_supported(ae_dev) \
 		test_bit(HNAE3_DEV_SUPPORT_GRO_B, (ae_dev)->caps)
 
-#define hnae3_dev_fec_supported(hdev) \
-	test_bit(HNAE3_DEV_SUPPORT_FEC_B, (hdev)->ae_dev->caps)
-
 #define hnae3_dev_udp_gso_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, (hdev)->ae_dev->caps)
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6962a9d69cf8..ded92f7dbd79 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1179,7 +1179,7 @@ static void hclge_parse_fiber_link_mode(struct hclge_dev *hdev,
 	hclge_convert_setting_sr(speed_ability, mac->supported);
 	hclge_convert_setting_lr(speed_ability, mac->supported);
 	hclge_convert_setting_cr(speed_ability, mac->supported);
-	if (hnae3_dev_fec_supported(hdev))
+	if (test_bit(HNAE3_DEV_SUPPORT_FEC_B, hdev->caps))
 		hclge_convert_setting_fec(mac);
 
 	if (hnae3_dev_pause_supported(hdev))
@@ -1195,7 +1195,7 @@ static void hclge_parse_backplane_link_mode(struct hclge_dev *hdev,
 	struct hclge_mac *mac = &hdev->hw.mac;
 
 	hclge_convert_setting_kr(speed_ability, mac->supported);
-	if (hnae3_dev_fec_supported(hdev))
+	if (test_bit(HNAE3_DEV_SUPPORT_FEC_B, hdev->caps))
 		hclge_convert_setting_fec(mac);
 
 	if (hnae3_dev_pause_supported(hdev))
@@ -3232,7 +3232,7 @@ static void hclge_update_advertising(struct hclge_dev *hdev)
 static void hclge_update_port_capability(struct hclge_dev *hdev,
 					 struct hclge_mac *mac)
 {
-	if (hnae3_dev_fec_supported(hdev))
+	if (test_bit(HNAE3_DEV_SUPPORT_FEC_B, hdev->caps))
 		hclge_convert_setting_fec(mac);
 
 	/* firmware can not identify back plane type, the media type
