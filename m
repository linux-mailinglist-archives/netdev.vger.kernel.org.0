Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5278516ACA4
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 18:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgBXRGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 12:06:47 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33615 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbgBXRGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 12:06:47 -0500
Received: by mail-lf1-f66.google.com with SMTP id n25so7348817lfl.0
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 09:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=date:in-reply-to:references:mime-version:content-transfer-encoding
         :subject:to:cc:from:message-id;
        bh=qPiprPPWOXKnPPDBG4O0xCF4AFbKQDRfeTyRm4fHf48=;
        b=T6711nbGJFtACfO8Li5uHflBgNtZ9UemEEG66EgJSxj7oeeXGJKDF14QhR3U/bVPGK
         CcDbQJcXp3wgFeKxl79HhwVvEuWAH3bkMNzuAeNm3pIZGPugPDkJxXNHuO+hFIPqO+V4
         nPzzkesTKw9jiIOQwznxCTCIKeo+0vy89ubD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=qPiprPPWOXKnPPDBG4O0xCF4AFbKQDRfeTyRm4fHf48=;
        b=WMpHy4VkrQZcb84MoXoq/UYfubmyLHFO9RSz2LhOxYrsiBhqxVAU1pUI5tMNhNhFvM
         dCQEX9ylEPKVH9RI0/hBOJhVD05pu6F9KzQ/0hbfPBpuBIL/A1DVQ7S3ytzrBff3mrXZ
         LijnPoO77houBksWk2nOLimyKF/38wKCcq5gRjmKm2yA8NbA9DQd1YBl+f72UVQIJCtk
         mCj6FmvXQB496JJEwMU8fYxCUCCMjZAJ7bOk+a878xS6Svp0iD8xC0wKg3RjJ8aCLoIu
         QG5EOAqRYg9327aDZr9abCGXJAfPcLqs0h2YPLaULpjrgR5QigVPwOynTChKtuvjhIvD
         owTA==
X-Gm-Message-State: APjAAAWGRNXqRc1icTMWUZy9VRaUoDG8vuGOlsrGKjFPsnpnxIOMtlpN
        2U6ippcNR/xATuR2GiM4+FQx1w==
X-Google-Smtp-Source: APXvYqw1TQnGxwF1ueBPFszBUMAPIyzp0xxQ7Ya/FLVeZcFyR7tZFURr2pGkefc+O83L7yZ+Gi5szg==
X-Received: by 2002:a19:c70c:: with SMTP id x12mr1338812lff.210.1582564003967;
        Mon, 24 Feb 2020 09:06:43 -0800 (PST)
Received: from localhost ([149.62.205.95])
        by smtp.gmail.com with ESMTPSA id s22sm6701675ljm.41.2020.02.24.09.06.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Feb 2020 09:06:42 -0800 (PST)
Date:   Mon, 24 Feb 2020 19:06:39 +0200
In-Reply-To: <20200224085427.0358ed8c@hermes.lan>
References: <83cadec7-d659-cf2a-c0c0-a85d2f6503bc@cumulusnetworks.com> <20200224164622.1472051-1-nikolay@cumulusnetworks.com> <20200224085427.0358ed8c@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net v2] net: bridge: fix stale eth hdr pointer in br_dev_xmit
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     netdev@vger.kernel.org, davem@davemloft.net,
        roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org
From:   nikolay@cumulusnetworks.com
Message-ID: <D49B5587-5365-4B09-9728-0BE23056A974@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 February 2020 18:54:27 EET, Stephen Hemminger <stephen@networkplumber=
=2Eorg> wrote:
>On Mon, 24 Feb 2020 18:46:22 +0200
>Nikolay Aleksandrov <nikolay@cumulusnetworks=2Ecom> wrote:
>
>> -	eth =3D eth_hdr(skb);
>>  	skb_pull(skb, ETH_HLEN)
>
>you could just swap these two lines=2E

Can't, still caching the wrong mac_header offset=2E br_allowed_ingress() c=
an change the head pointer and also the offsets inside=2E=20


