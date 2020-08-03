Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36B023AA45
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgHCQMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:12:43 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42315 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728360AbgHCQMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:12:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0B3165C00D2;
        Mon,  3 Aug 2020 12:12:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 03 Aug 2020 12:12:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=s1AUYfAnmw6H+N5JBZO9kTHlKfRdVP1yH7LdD5+8G+o=; b=nemwfv5b
        P6f7XsXqezHKG8UOZA94yvW7BX039Kk3uCGGfTTbe4A7skBww1ldfKqi2bLGKpcW
        zboIxyGLj9KOqsXQWnrClbdmWOfLPnAKYGN/fOCDd1mDvpgaCIqwdgbYF7XKEtow
        fIKIWL7L8Obqdecf2XLw+cy8iVjvN2O8HfP6JZWTdeGQJn98v1mvwQJriv7VMNtD
        BYaGMQSlsN12JHktmeiBTsnAimifKodgyTI/cvGmrJ8fsoXe+i+uMz7mJnkZ1BP5
        x891814IqILrwYjfQd57w8QhmA8cyxedNPAgkuexy82gfgaKtYkWYAX50nSdNTbL
        oqZG77sJj0Azew==
X-ME-Sender: <xms:dzcoX07Lr0-rkjMhDrYBRUftPrmct_QLM6nNWepClE4t-K6VZSbxtA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeggdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddukedurdeirddvudelnecu
    vehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:dzcoX17AXzYcwpZGwLaKWehc0KYAFQJdmUlAUsyOJTnkGZtC2_t7_A>
    <xmx:dzcoXze0of_HhpFScs55TnC3-LWYyI_ac5A93QYacfsA29OH522Cyg>
    <xmx:dzcoX5KRWjmA60YLjQfumByOsYVHMD7-PiRDXbfUCFFw670MCzt_wQ>
    <xmx:eDcoX829lM8vhqAkqpe-5Xya_v31qeSUgSS3l13OUIMjLkolkvnrqg>
Received: from shredder.mtl.com (bzq-79-181-6-219.red.bezeqint.net [79.181.6.219])
        by mail.messagingengine.com (Postfix) with ESMTPA id 348C73060067;
        Mon,  3 Aug 2020 12:12:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/9] mlxsw: spectrum_span: On policer_id_base_ref_count, use dec_and_test
Date:   Mon,  3 Aug 2020 19:11:36 +0300
Message-Id: <20200803161141.2523857-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803161141.2523857-1-idosch@idosch.org>
References: <20200803161141.2523857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

When unsetting policer base, the SPAN code currently uses refcount_dec().
However that function splats when the counter reaches zero, because
reaching zero without actually testing is in general indicative of a
missing cleanup. There is no cleanup to be done here, but nonetheless, use
refcount_dec_and_test() as required.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 323eaf979aea..5c959a995199 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -837,7 +837,8 @@ static int mlxsw_sp_span_policer_id_base_set(struct mlxsw_sp_span *span,
 
 static void mlxsw_sp_span_policer_id_base_unset(struct mlxsw_sp_span *span)
 {
-	refcount_dec(&span->policer_id_base_ref_count);
+	if (refcount_dec_and_test(&span->policer_id_base_ref_count))
+		span->policer_id_base = 0;
 }
 
 static struct mlxsw_sp_span_entry *
-- 
2.26.2

