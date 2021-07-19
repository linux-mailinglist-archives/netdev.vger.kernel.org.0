Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960483CD1E6
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 12:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbhGSJsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 05:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbhGSJsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 05:48:51 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F4CC061574;
        Mon, 19 Jul 2021 02:35:54 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id ee25so23232829edb.5;
        Mon, 19 Jul 2021 03:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j9gP2F+YGBN0qB5vck/z1iGx6N0mtdgkTdRUqd67V0g=;
        b=uzrDuYDUd+RfvoZDiB91XqYOGOCSEReAGKLoVF1VROGbS1obAwYnMBR2Yl0gCQr7YS
         A81JmUioX4IwTAM/eDnGuST9n6Ef1wWN2ilZgn5msqwKjUKtz44s6zWM2e2ouvbNdqji
         uiApX+59EkT+UY2wOrbkFW75TIXXnQRZuR8lkKyp7J9HPV06BVylS9EhawHTS8/CYpRG
         EXJ/viD2ev3qTZMZQK03Mj+CDSg+6AtOTg2yHf5eJ+StHBPfhmZhM4zQisTVoyv4ZQln
         0gJidaGL/KkGqlJ5YMzo4rHRJBEbfa8xSf8lpJDcJYJICi2o7w6p8nJO5zJk4rR/rdaq
         uV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j9gP2F+YGBN0qB5vck/z1iGx6N0mtdgkTdRUqd67V0g=;
        b=UWwlsoFk8vcV+CzjMjQ5Qk+jDYpZQYXT85IxAa8qGW99roXoQ2275lUbO4qzl+fZRC
         VjBBG5j8ms4bklKJwZKr7C1qZgLX+B33Py0DYSHpPURAp6D+N2skxVuDULdZCxhLWV88
         QSGhrnZXLccPT72ZGir4S8nltW68DctKikyZBoCWBsM2EJsAVXVlsXvUTr64CrPm0bdE
         8+LRwO+ygdnQOt5DrSA+dnKMw7fKmqcbjI1jBPTSuXLXJgfCpxzFy/A+w1QGiiTxKbv5
         4jkSswlTkIu5mLylClfO9xaLJXEvBHIiHwLBREakJx3NLUFP6EcKhUNy68M66fAnldj3
         GgPA==
X-Gm-Message-State: AOAM533y3ws4g+f1DX+UPd99tdwbfZJSM+ib838uWqhIYkh8kvvPBgO4
        rlw7mgfivL0DValt6O1Y5NY=
X-Google-Smtp-Source: ABdhPJwQuUV7z6kjbx+5k8/6gbEPrKUq2ljUYr9TQ9vtcraVQi8KK3bShyskFr5eNbDSUxPxNIsJqg==
X-Received: by 2002:a05:6402:3507:: with SMTP id b7mr34063732edd.254.1626690569374;
        Mon, 19 Jul 2021 03:29:29 -0700 (PDT)
Received: from localhost.localdomain ([176.30.236.194])
        by smtp.gmail.com with ESMTPSA id d9sm5767029eje.34.2021.07.19.03.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 03:29:29 -0700 (PDT)
Date:   Mon, 19 Jul 2021 13:29:24 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+13ad608e190b5f8ad8a8@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: 802: fix memory leak in garp_uninit_applicant
Message-ID: <20210719132924.13c9f063@gmail.com>
In-Reply-To: <20210719120541.7262fc70@cakuba>
References: <20210718210006.26212-1-paskripkin@gmail.com>
        <20210719120541.7262fc70@cakuba>
X-Mailer: Claws Mail 3.17.8git77 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Jul 2021 12:05:41 +0200
Jakub Kicinski <kuba@kernel.org> wrote:

> On Mon, 19 Jul 2021 00:00:06 +0300, Pavel Skripkin wrote:
> > Syzbot reported memory leak in garp_uninit_applicant(). The problem
> > was in missing clean up function in garp_uninit_applicant().
> 
> Looks like it's fixed in net by commit 42ca63f98084 ("net/802/garp:
> fix memleak in garp_request_join()"), would you mind double checking
> that fix and closing the syzbot report manually?
> 
> Similar with your MRP patch and commit 996af62167d0 ("net/802/mrp: fix
> memleak in mrp_request_join()").

Hi, Jakub.

Yes, these patches are identical, so I will close the syzbot bugs
manually. Thank you for pointing it out.



With regards,
Pavel Skripkin
