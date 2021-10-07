Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BC64252D0
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 14:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241239AbhJGMQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 08:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241135AbhJGMQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 08:16:53 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED4DC061746
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 05:15:00 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id t2so5839665qtx.8
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 05:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=aEhHKcrm3Q2wts8x01ERR1MnXq1LQlp9dlYZdAuwkto=;
        b=mfQTyz7tqoal3I1L58j0iIRm2sdgPg2vm+GZIjCBsNPrI3qrFxjiuIfcAuFe+do46s
         0wi9HjKTAR2ORlecnDqqdEgHM7CujNUhSftihEJni9wGqEdTWtNrN0v2cMMqu3+/Vewy
         jvtZRTNqlDx7xhEUa6FqUzCNk+2si9TscoqTMsm/fVUaKdRH0AVxj8fay6qqdg9TVVF3
         hHbD+XUVpjS2SK2vLlwlPIh3qMJ4fJS6y9pJdTtAQX3dkU/V8EjrRaY71DnwFzepXuCo
         Du5zEtsNC1onC5tMrfC8wd44rtrOpejFRlV4LNzPxIKH/9LMU1GToNFCubXgHwm/78Uj
         K1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=aEhHKcrm3Q2wts8x01ERR1MnXq1LQlp9dlYZdAuwkto=;
        b=josBSomBCPxOgtaTLkuLP90J6Ggoiw6tz2NYaVcIChe/9sRhEJEfO5kxq0dsElvj4j
         GdKe26phXqEEmSbn3wNYt+R6ne+h2qT1XRsWcr+O6YeYF3K/jbKz92DlNNCRYh3IejtL
         bFOF9Gr3jyizS5BqUPWhIThbwt6UXPoe/D23wjCm9plCRB3DHQrktKmlnoUOEDEHEfix
         E3dZqAD/Ci+vlB90N/O6ZCX1GJIGUa5i3u/Jh3t8t/coC5m2KhFzRdRko/Y5In0DmvC6
         j/2GzGHmLwaGV4XETaFBcAG7otS6+r5kZwsmri/cKP4lGSMW4CICm8KpKJRO4ICjarji
         ywdQ==
X-Gm-Message-State: AOAM532wk7c9rVHTt5rA7YKWHrAKJmECmB3zXfXZoxoNqqELwAUsqeq2
        Yqw9hb5AI0oFrJ6ZOAuzJP8eRuld0g==
X-Google-Smtp-Source: ABdhPJxMuzodVqSCAItEKgrBvoPuGwFa7BR6VgxbSkHmn2lvSMDKrKDpz/PyCRohFVAadX02BV8/pw==
X-Received: by 2002:ac8:7384:: with SMTP id t4mr4442679qtp.83.1633608899163;
        Thu, 07 Oct 2021 05:14:59 -0700 (PDT)
Received: from EXT-6P2T573.localdomain ([12.226.21.85])
        by smtp.gmail.com with ESMTPSA id t64sm13732302qkd.71.2021.10.07.05.14.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 05:14:58 -0700 (PDT)
Date:   Thu, 7 Oct 2021 08:14:51 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Subject: ip_list_rcv() question
Message-ID: <20211007121451.GA27153@EXT-6P2T573.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Under what condition that ip_list_rcv() would restart the sublist, i.e.
that the skb in the list is having different skb->dev?

void ip_list_rcv(struct list_head *head, struct packet_type *pt,
		 struct net_device *orig_dev)
{
	...
	list_for_each_entry_safe(skb, next, head, list) {
		...
		if (curr_dev != dev || curr_net != net) {
			/* dispatch old sublist */
			...
			/* start new sublist */
			...
		}
		...
	}
	...
}

In my system, the function gets called from the following call chain:
net_rx_action()->napi_poll()->gro_normal_list()

It seems to me that there is one to one relationship between napi_struct
and net_device, but I saw an archived discussion about it might be one
to many. But I didn't see it.

Thanks in advance for the clarifications.

Regards,
Stephen.
