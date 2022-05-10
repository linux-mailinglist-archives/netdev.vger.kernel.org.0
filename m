Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C15521F33
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244173AbiEJPpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243916AbiEJPpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:45:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42423C4B7;
        Tue, 10 May 2022 08:41:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AFA66137D;
        Tue, 10 May 2022 15:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800CCC385C2;
        Tue, 10 May 2022 15:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197264;
        bh=gqCPYvwaXq1HHzFT7PPYDVj1xG98Nrh9/uLDsEF5+9g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TavP+gWuT+m1YnIchkwlb/z8f4b8mu3qKiWZoFXmdov2wBXdnRFmk65ZhpnQLF4W5
         h5UoSNzV2ujZClf9tfemHkpVjs1gi+EKnqhUMZvHT9WupRkioXFsK7Nd58/Sgknel4
         zyagdyQ6jbWuCuckiGl78MS/snesuMQVz7s41Gv11q3XnX+g1ZMsBDmfvjrlH4gz99
         g+FiRNOS5Gr7RoAhJc9Ji5AgF3jbqGMwS2bvGAMmhcrGAvexaZWUlsSW7t122nLJzU
         TJv1e2YQZQUlZT+MM4ymA3lfmMJvjz6xRU9A4qFi9SOZT7lLloyyUSIuREQwCyIB+S
         RWeSTHySN1V+g==
From:   Kalle Valo <kvalo@kernel.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     netdev@vger.kernel.org, dianders@chromium.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v3] ath10k: improve BDF search fallback strategy
References: <20220509022618.v3.1.Ibfd52b9f0890fffe87f276fa84deaf6f1fb0055c@changeid>
Date:   Tue, 10 May 2022 18:41:00 +0300
In-Reply-To: <20220509022618.v3.1.Ibfd52b9f0890fffe87f276fa84deaf6f1fb0055c@changeid>
        (Abhishek Kumar's message of "Mon, 9 May 2022 02:26:36 +0000")
Message-ID: <87a6bp8kfn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> writes:

> Board data files wrapped inside board-2.bin files are
> identified based on a combination of bus architecture,
> chip-id, board-id or variants. Here is one such example
> of a BDF entry in board-2.bin file:
> bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_XXXX
> It is possible for few platforms none of the combinations
> of bus,qmi-board,chip-id or variants match, e.g. if
> board-id is not programmed and thus reads board-id=0xff,
> there won't be any matching BDF to be found. In such
> situations, the wlan will fail to enumerate.
>
> Currently, to search for BDF, there are two fallback
> boardnames creates to search for BDFs in case the full BDF
> is not found. It is still possible that even the fallback
> boardnames do not match.
>
> As an improvement, search for BDF with full BDF combination
> and perform the fallback searches by stripping down the last
> elements until a BDF entry is found or none is found for all
> possible BDF combinations.e.g.
> Search for initial BDF first then followed by reduced BDF
> names as follows:
> bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_XXXX
> bus=snoc,qmi-board-id=67,qmi-chip-id=320
> bus=snoc,qmi-board-id=67
> bus=snoc
> <No BDF found>
>
> Tested-on: WCN3990/hw1.0 WLAN.HL.3.2.2.c10-00754-QCAHLSWMTPL-1
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>

[...]

>  static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
>  					      const char *boardname,
> -					      const char *fallback_boardname1,
> -					      const char *fallback_boardname2,
>  					      const char *filename)
>  {
> -	size_t len, magic_len;
> +	size_t len, magic_len, board_len;
>  	const u8 *data;
>  	int ret;
> +	char temp_boardname[100];
> +
> +	board_len = 100 * sizeof(temp_boardname[0]);

Why not:

board_len = sizeof(temp_board-name);

That way number 100 is used only once.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
