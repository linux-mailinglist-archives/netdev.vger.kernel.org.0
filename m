Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B92437C05
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhJVRiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbhJVRiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:38:03 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700C0C061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:35:45 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q187so3972723pgq.2
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yt+W6eVuKo3tbTyRVFHpOdyh1Q7ZOR4h5mTr7QRIVOI=;
        b=NxsYNcvdNW4+fJ09l+Q1EzATkAWxA44A4QIMphs6zLJ/mtrx0kOnxdUxR3J8AV/qt2
         +lPeVkgUXseWLlYI12smyGqWQNsUENVsxwtEY+MA3UnssLqlQbNzTCI5SbRfWA6/fjMR
         1bzDHYxIlnTatsZEgQPtDALTcw3vIVYTFx0rJXUtVBb4w1LmiMK+7/NCUSMwuB/Jmb63
         YC9ky34iA1Fh2kjrRadXW/sfWQNVzxqNhV8FjNtnEq3ELQMtIkYOs5wDubUz+olt+DjT
         6oYQ+7YeQOQkaGTXvjJ10kVxQ/HNJUox5+akmH9lJSqg6lH/gVyf5SKoE8+ev5EoDnkg
         F10Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yt+W6eVuKo3tbTyRVFHpOdyh1Q7ZOR4h5mTr7QRIVOI=;
        b=kh1LknLAe6Tc9sAlY0SoBIF9bfvK4J3PiBaiLF2kT1gfiDLnVhgNYRr3q/vAx9ZHqL
         wmqhdKxO4/D86IyfTwgdn9TS5uFesheJCcTmD5BY9rAuU3FaPmud/2qKbvnehwscIbHZ
         uZL61F9QUa/9VI6P4mosKOq/DlliMXpy9es1IiZHYKu9jKmhL0SOdMz49XuRQX9bjVHE
         XAGLEdujss3rzreetEhVOd0W1hZf+LZZEgaipvZFMoBKrTrwriKyWTfPxng2G/PFwcKJ
         Dzq3Z2LvCjhcXHjrmKkn9EZQ+bbqzDauVuIU/pcaaEItg0WtHu80Wp2DZc1T6ILwYOJt
         EqUQ==
X-Gm-Message-State: AOAM53150GONezdxP1zPRbYfRJFGn8/kCX2MzVqj9J8TQ2CEjvotMO4l
        IKh6JGrKSdU+Tkxrw8wH7iM=
X-Google-Smtp-Source: ABdhPJyji4JYjR7jWUZX7d/gFSPf+DrY8IF/xCRL9fCaq83cK+7Ou7b5jdhdw+OwIeUZd9HkWxvZOQ==
X-Received: by 2002:a62:7752:0:b0:44c:eb65:8561 with SMTP id s79-20020a627752000000b0044ceb658561mr1385034pfc.43.1634924145004;
        Fri, 22 Oct 2021 10:35:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w5sm8709169pgp.79.2021.10.22.10.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 10:35:44 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 2/9] net: dsa: sja1105: serialize access to
 the dynamic config interface
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
 <20211022172728.2379321-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bb0eb6f3-a5db-0966-5564-b53d3a6073c6@gmail.com>
Date:   Fri, 22 Oct 2021 10:35:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211022172728.2379321-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 10:27 AM, Vladimir Oltean wrote:
> The sja1105 hardware seems as concurrent as can be, but when we create a
> background script that adds/removes a rain of FDB entries without the
> rtnl_mutex taken, then in parallel we do another operation like run
> 'bridge fdb show', we can notice these errors popping up:
> 
> sja1105 spi2.0: port 2 failed to read back entry for 00:01:02:03:00:40 vid 0: -ENOENT
> sja1105 spi2.0: port 2 failed to add 00:01:02:03:00:40 vid 0 to fdb: -2
> sja1105 spi2.0: port 2 failed to read back entry for 00:01:02:03:00:46 vid 0: -ENOENT
> sja1105 spi2.0: port 2 failed to add 00:01:02:03:00:46 vid 0 to fdb: -2
> 
> Luckily what is going on does not require a major rework in the driver.
> The sja1105_dynamic_config_read() function sends multiple SPI buffers to
> the peripheral until the operation completes. We should not do anything
> until the hardware clears the VALID bit.
> 
> But since there is no locking (i.e. right now we are implicitly
> serialized by the rtnl_mutex, but if we remove that), it might be
> possible that the process which performs the dynamic config read is
> preempted and another one performs a dynamic config write.
> 
> What will happen in that case is that sja1105_dynamic_config_read(),
> when it resumes, expects to see VALIDENT set for the entry it reads
> back. But it won't.
> 
> This can be corrected by introducing a mutex for serializing SPI
> accesses to the dynamic config interface which should be atomic with
> respect to each other.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
