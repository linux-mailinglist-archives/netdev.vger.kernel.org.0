Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9048F61C
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 23:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbfHOVBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 17:01:51 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40762 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfHOVBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 17:01:51 -0400
Received: by mail-pf1-f194.google.com with SMTP id w16so1931398pfn.7;
        Thu, 15 Aug 2019 14:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=4T64qkcAdXmbepae4c9HCTfQGPBnJoejyWFEjIneg2s=;
        b=RN9JoNnS4VX0rzGS2CSyjnUzPIPErSpNO8+HGiJvK6ZIxUwz6q+/aZsqvLfBetDQ5S
         iMa4wkqjaCQytGxrsOSIAebJ08Sx00bEiI2x9SFU9F6978G0e4ndNwZIzjrkZkVe4KTF
         H+ebL06LoowsGWpHJ6gZCEQXEfHl39a8zr9PaiPUpvn6dNy22g9oA2y+dzYIOj3HtZ6O
         gLQ60pqFPuni4FhgBzdNCXd8CIc+naFzs48zdPoDM+OxUd8DC8s94gVgmfor4QUKSdbS
         WVkqNbtY5pu2fqpLhMiWMb+YIZLlbCdm1UkhIOzpwBAUcfRxY0fZzsZNEsH/Hwh4ToT5
         LZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=4T64qkcAdXmbepae4c9HCTfQGPBnJoejyWFEjIneg2s=;
        b=p+9QFkKAxJlo0B7WRg1SWLfX0/U2rskFIDFw/FfDuNWhtLxM+S0nSIb+gZHhpUPzAp
         CYs/j6g5vn1XFtHuFoBeGBHZ1ZAUdmrsC5puZAZvs5rJJmV4ZjpAaqV08pTULD8tm+V+
         X7B1P0WhGzb4zrf/qHwVKtnn/eW73LzL7pwErqMV5YeLjhtJfAszyOYs5cw6ReeOMk+s
         QCDlrelXNFOZG3CwIuZLFH9p9H/xTk8+NZQONxVR2W/9AchrAwHiorp6uqKJOSqGpWxn
         mpueCnPyRpViF2ppR6T2+KGedVb7uztj6OT2bLAFlD8vDf/ecwvnrB1++Q11l6E8C2Lt
         fiKw==
X-Gm-Message-State: APjAAAWbvtneQXQ1604JMhV9FoR+R97eZZed4JAuSz7MYbValWp9vQ/L
        d9F+WoM3ZSsvslKAqPYAUgY=
X-Google-Smtp-Source: APXvYqzoyCZOMcdfxkJb1szIM39Ur1skzzb4WHfq9bjFGTO4eIIks53+RyyheGBGWshT0f+I9dUqgQ==
X-Received: by 2002:a17:90b:949:: with SMTP id dw9mr3974290pjb.49.1565902910671;
        Thu, 15 Aug 2019 14:01:50 -0700 (PDT)
Received: from [172.20.53.208] ([2620:10d:c090:200::3:fd5d])
        by smtp.gmail.com with ESMTPSA id 195sm4163508pfu.75.2019.08.15.14.01.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 14:01:50 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Ivan Khoronzhuk" <ivan.khoronzhuk@linaro.org>
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf 1/1] xdp: unpin xdp umem pages in error path
Date:   Thu, 15 Aug 2019 14:01:48 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <1194DC32-76CC-4C7E-9D21-47886C704367@gmail.com>
In-Reply-To: <20190815205635.6536-1-ivan.khoronzhuk@linaro.org>
References: <20190815205635.6536-1-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Aug 2019, at 13:56, Ivan Khoronzhuk wrote:

> Fix mem leak caused by missed unpin routine for umem pages.
> Fixes: 8aef7340ae9695 ("commit xsk: introduce xdp_umem_page")
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
