Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBDB6C1250
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 13:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjCTMuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 08:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjCTMuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 08:50:02 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5BA13D;
        Mon, 20 Mar 2023 05:49:04 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id w9so46288438edc.3;
        Mon, 20 Mar 2023 05:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679316543;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=csxAzmG1ZxKtRVplzZVDXPj/0poXWCzMsfVoYIpxsHo=;
        b=psP7AcHp6cs05EyNdk/JlAmNSWWp/abjwa4VMtyGVWtp5N1SwktW+/5uEcOrIA150T
         /6HjoS6ZYJyFracc8i1TaJhVew4dUJa1pSDDnlKInLJWkibXoUblSs3hRJliF0oGdtlG
         +7NY/g9s3a/bz+vbQFFM578m3cmqLyYHx1w6NA89zpScfH0Q1+qPtoNtAHCKaPyolUnE
         I0xD0eJi1J5J+H6azy/zgrtxSCHGTvgVTVT64inFDe382vpd/bSJ9GiFWcyFLj62IVwF
         GLzg+XRH/P8fBQ1l81STEFO+y62S0luvD7JHRv2MW7D8MxnHaER4On3SUaS1/QX2ylTS
         tdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679316543;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=csxAzmG1ZxKtRVplzZVDXPj/0poXWCzMsfVoYIpxsHo=;
        b=bVV2ALJsFtmDp7e6kTLixlK9n7hPd+TbVM3NqO+lAF5M+Z3G40H4S2AvfqJNuP4I0L
         I59TQDL7sdZHlg6nrK2tq06/TGh3N9ffY3bf6wPOjKt3k24GUT3kvvI7RrVVAgWVBFik
         D3cPWCgDpNutDrhYNbklpU5QpqKpvlmTR26Br33b09uChoBszmKFRXRHDZ0902uo0onb
         /jckDzPIKkWnr7mVQlQV/vwnQhf+gwvTD4IUkVd4v0P1cFGY1Vg6uE/PYpAHX+fFEr+t
         2I+UJRo5S6RBCUiNaxjcj1/jO8W4DW7a9wK97c5fMVRYKIEQAYligpzObZEvKgXOVwuG
         yt+Q==
X-Gm-Message-State: AO0yUKXJUvjo6Az10qtfIehH11f/+UP8tg6LOu6aKjqVHitsuI2sdxu6
        95m2sWtC5w7uUre2fpy9Nsk=
X-Google-Smtp-Source: AK7set9nqiT/JpUhH6DDvPBLRfg/UjuncOawlqG5xE/I+ZlQ89l4YxS91ZHtVhWVEIXGEfESH+gY8g==
X-Received: by 2002:a17:906:5655:b0:921:da99:f39c with SMTP id v21-20020a170906565500b00921da99f39cmr10203540ejr.12.1679316542823;
        Mon, 20 Mar 2023 05:49:02 -0700 (PDT)
Received: from [127.0.1.1] (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id g26-20020a1709064e5a00b00930525d89e2sm4353779ejw.89.2023.03.20.05.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 05:49:02 -0700 (PDT)
From:   Jakob Koschel <jkl820.git@gmail.com>
Date:   Mon, 20 Mar 2023 13:48:15 +0100
Subject: [PATCH net v2] ice: fix invalid check for empty list in
 ice_sched_assoc_vsi_to_agg()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230301-ice-fix-invalid-iterator-found-check-v2-1-7a352ee4f5ac@gmail.com>
X-B4-Tracking: v=1; b=H4sIAA5WGGQC/5WOSw7CMBBDr1LNmkFpwq+suAfqIp9pM4KmKCkRq
 OrdSXsDlrblZ8+QKDIluFYzRMqceAxFyF0F1uvQE7IrGqSQSihRI1vCjj/IIesnO+SJop7GiN3
 4Dg6tJ/tAoRUdzUG5zigoKKMToYk6WL/CBp1Kaw1ekQps279DoAnaYnpOBfjdPuV6i/6bzzXWe
 DlbeXJErmmaWz9ofu7tOEC7LMsPhAedC/YAAAA=
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1679316541; l=2523;
 i=jkl820.git@gmail.com; s=20230112; h=from:subject:message-id;
 bh=k5p5ktQnCBxgX1LUGONT7ZulaFqVVOQWI0ZWXkqT+M4=;
 b=+pHQ+5iJaOQJSjxW6v3N28uZ6Z/ilNRaLOfE4c8rCRFUbcBfIoHTWsM/bC5vPTiDSjoQ5orqddMb
 VYTZv8IaBA7yJV/myuce+ivFL3EzbuFKs2Q4HSRZjwsAtKHHLI9a
X-Developer-Key: i=jkl820.git@gmail.com; a=ed25519;
 pk=rcRpP90oZXet9udPj+2yOibfz31aYv8tpf0+ZYOQhyA=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code implicitly assumes that the list iterator finds a correct
handle. If 'vsi_handle' is not found the 'old_agg_vsi_info' was
pointing to an bogus memory location. For safety a separate list
iterator variable should be used to make the != NULL check on
'old_agg_vsi_info' correct under any circumstances.

Additionally Linus proposed to avoid any use of the list iterator
variable after the loop, in the attempt to move the list iterator
variable declaration into the macro to avoid any potential misuse after
the loop. Using it in a pointer comparison after the loop is undefined
behavior and should be omitted if possible [1].

Fixes: 37c592062b16 ("ice: remove the VSI info from previous agg")
Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>
---
Changes in v2:
- add Fixes tag
- Link to v1: https://lore.kernel.org/r/20230301-ice-fix-invalid-iterator-found-check-v1-1-87c26deed999@gmail.com
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 4eca8d195ef0..b7682de0ae05 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -2788,7 +2788,7 @@ static int
 ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 			   u16 vsi_handle, unsigned long *tc_bitmap)
 {
-	struct ice_sched_agg_vsi_info *agg_vsi_info, *old_agg_vsi_info = NULL;
+	struct ice_sched_agg_vsi_info *agg_vsi_info, *iter, *old_agg_vsi_info = NULL;
 	struct ice_sched_agg_info *agg_info, *old_agg_info;
 	struct ice_hw *hw = pi->hw;
 	int status = 0;
@@ -2806,11 +2806,13 @@ ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 	if (old_agg_info && old_agg_info != agg_info) {
 		struct ice_sched_agg_vsi_info *vtmp;
 
-		list_for_each_entry_safe(old_agg_vsi_info, vtmp,
+		list_for_each_entry_safe(iter, vtmp,
 					 &old_agg_info->agg_vsi_list,
 					 list_entry)
-			if (old_agg_vsi_info->vsi_handle == vsi_handle)
+			if (iter->vsi_handle == vsi_handle) {
+				old_agg_vsi_info = iter;
 				break;
+			}
 	}
 
 	/* check if entry already exist */

---
base-commit: eeac8ede17557680855031c6f305ece2378af326
change-id: 20230301-ice-fix-invalid-iterator-found-check-0a3e5b43dfb3

Best regards,
-- 
Jakob Koschel <jkl820.git@gmail.com>

