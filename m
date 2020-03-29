Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6197C196E0B
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 17:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgC2PEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 11:04:42 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42221 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbgC2PEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 11:04:42 -0400
Received: by mail-pg1-f194.google.com with SMTP id h8so7404233pgs.9
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 08:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5o6vxMMDoqebgB7RHf9SAkZY46nTqQWWTAj/9AYxt9g=;
        b=bVt07RFud/G6Rp4yKDUljh5YHuBFGg9swFWp+otR3Hu9+P186aZPdCG3mGE4TkMVh9
         lAGkque7ZfbmgekVN/oQNz9uAjbbot4rRYl7WtZLKUvn2q9ECpNoLMvHPTNvlzFC6LI7
         4ChaFYsFgckEAXYYspxzSKQVrHNaX2Qoy3+Iz0CQTp2perv82fkGQ9ANUezmFsLT7+b6
         76iS+mnQCtK1E+7iiJPTom9qYoZy2TPKlZ3HAwGcVFxCuxWgefBX13Irfk3+xOunY5Un
         legXTLs0HY4enCWejhMtN4c/dvrQ39edBplS2dxi7V40pvcAUEolCAsP2c8cJHV+W57B
         wMew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5o6vxMMDoqebgB7RHf9SAkZY46nTqQWWTAj/9AYxt9g=;
        b=H6Doh0zqDfCpUYbEfM+GeQBMNnhoNmU4T6RLkYaCofangjdnJ/Rq/qPQfCwQv0N5u+
         yl3eHlOwgQ8R+PRt+zV+sIzWhA7LjLWCwnaPPu0bajlh/zj0eva3KibqR9lGMOQGTxqI
         qPlPVnG/zQNTsMVU5Tg07yLWHZ8pAA7n1EbXRqKo8f5tW0xAPbr8ggYt9eMiIPVX42xC
         KSsOOcs/Psf4Ix6WHxJyFyb830ajBhmcQZjVCI5cFmysF/HL99awUjqFQWWgqoJW0hqE
         wCKu0YE/W04nrPjGpfIF6fBF3X367X7H1MNBP/egXks/XRFFkE8930glia1aiBHMp/ts
         eToQ==
X-Gm-Message-State: ANhLgQ2XRyxc2rDNdCqR3Ca525hwfhjXCVM6U8Xoc2ccy9hchY1u43zV
        kvIsS5kGQZhwts/7M2nDDLYhAJzt
X-Google-Smtp-Source: ADFU+vs1Ow/GdVFIetGX3JZy8v6Sx6jCzN/GBm0zF9+D9ShPysyx+/ti4cbkuaDNVw1k9tKncj2e4g==
X-Received: by 2002:a65:6712:: with SMTP id u18mr8942680pgf.93.1585494280964;
        Sun, 29 Mar 2020 08:04:40 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id a24sm8227151pfl.115.2020.03.29.08.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 08:04:40 -0700 (PDT)
Date:   Sun, 29 Mar 2020 08:04:38 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, Yangbo Lu <yangbo.lu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next V2] ptp: Avoid deadlocks in the programmable pin
 code.
Message-ID: <20200329150438.GA1825@localhost>
References: <20200329145510.2803-1-richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200329145510.2803-1-richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 07:55:10AM -0700, Richard Cochran wrote:
> The PTP Hardware Clock (PHC) subsystem offers an API for configuring
> programmable pins.  User space sets or gets the settings using ioctls,
> and drivers verify dialed settings via a callback.  Drivers may also
> query pin settings by calling the ptp_find_pin() method.

Sorry, forgot the ChangeLog for V2:

- fixed spelling in the kernel doc
- add Vladimir's tested by tag
