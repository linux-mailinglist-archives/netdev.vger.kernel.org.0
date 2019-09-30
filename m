Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 780ACC2AD8
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 01:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732421AbfI3X1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:27:50 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45192 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730573AbfI3X1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:27:49 -0400
Received: by mail-qk1-f195.google.com with SMTP id z67so9415701qkb.12
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 16:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=z4XfeDfVTC6jpFVrzO8aInAPasvixt3qBNNHrmWemDI=;
        b=dzQej7KKP6Ik9zJc8GTOpb50oQgsb7eghPgWvMzTKybn6i1Vaci0TwuYv0CHmf+PIg
         34aEj99/rGfGRcf4tramwx5QNs2uqIsM0mh3bu92eACAlNARQYWdiUpoS72Wxq4FRd82
         u8wRLqM8j7VJ5WX39hMnV7hWsZ1cnLNtpeC3yFowqw5ZwF7r43I9GYN001UItXIlzA1F
         vOwbPzGwdlagE5ebZwroVrnmTpgjz5obKP987x/Rx9w5ezm026Gka9h+A5ZdaceuQWp7
         eJYxFnsIB0HhMQjH7cHk/dDrN97UsnXbyRNTeRPKoeGWhSG3i4U6HKXsWgLNmirJIsbs
         p8rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=z4XfeDfVTC6jpFVrzO8aInAPasvixt3qBNNHrmWemDI=;
        b=d5mcxlYlLIKl5TVuzPrCQZryCYN7vh7wO2CyxsKg0Hsa5mYe5c21vXXi8XsqJihVJC
         QDOT/a/98aUT8Oclr9bruPmT95f9I1X75aky2zHFptyqogh/enodF5+CcyrNf28sobIE
         eRUxsruPNa3B16phWPdkQxXouVjJttcYtJlDzG5PxgJr9AMn3ha3wr8ePQxNo19Pi8Ni
         h420okz9bMi5DxEXiTye5PL4B8rETZ9IU7HcGD5EbFeswdc9KVV1FLuG6ngLfIkPkA9n
         5s8ONdQUt1cZIE05CwschFR4Tutq6AE0YRmSqqCkjyrFJ2JVgasZtNi7ORvGfvMKdWLp
         PQjQ==
X-Gm-Message-State: APjAAAXcF7S/ZeGMnFVwK0j8cC5FqMJ7dVMLGkqeavcaDtk1TV4Hii9q
        L16N/iv+nVRi9kKSxKalgtRkAcG/WuI=
X-Google-Smtp-Source: APXvYqzRK3PIrcwFSTf1KoXc6bEn7tYxdsbAVs3fvq+5Ll/Ex079lJYunZYuZPZ4qLJ5AeHtLOpVKg==
X-Received: by 2002:a37:a00d:: with SMTP id j13mr3045251qke.2.1569886067683;
        Mon, 30 Sep 2019 16:27:47 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m19sm6827575qke.22.2019.09.30.16.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 16:27:47 -0700 (PDT)
Date:   Mon, 30 Sep 2019 16:27:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 2/5] ionic: use wait_on_bit_lock() rather
 than open code
Message-ID: <20190930162744.62e75a2e@cakuba.netronome.com>
In-Reply-To: <20190930214920.18764-3-snelson@pensando.io>
References: <20190930214920.18764-1-snelson@pensando.io>
        <20190930214920.18764-3-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Sep 2019 14:49:17 -0700, Shannon Nelson wrote:
> Replace the open-coded ionic_wait_for_bit() with the
> kernel's wait_on_bit_lock().
>=20
> Fixes: beead698b1736 ("ionic: Add the basic NDO callbacks for netdev supp=
ort")

Again, slightly strange to see the Fixes tag for code clean up
targeted at net-next, but perhaps my views on Fixes tag differs=20
from the general consensus =F0=9F=A4=94

> Signed-off-by: Shannon Nelson <snelson@pensando.io>
