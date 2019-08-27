Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA3D09F6BE
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 01:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfH0XRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 19:17:19 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35985 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfH0XRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 19:17:19 -0400
Received: by mail-pf1-f196.google.com with SMTP id w2so381238pfi.3
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 16:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=o0SYpITCq+PSSMeMLJ7UG8q5bBiF679tRTj0DAn+kqA=;
        b=WpN1QEGitn85KZQOU4uKaxIAOyuI9pO3a+0+9An/5FeaBGpP6JEXwu031J53pxp2Ca
         FYKcy5wEJuxPmCDdn+dQBTmdUeQqiRsXHh8aufVCRptJ+6bREachha1NK9UOK0YFoji1
         sgwYZpaOAbBhEIGgDJPTpQTiRYonqGG3VbleLDm0j7vV/Ij0q9I1LaIOs3cdy2DYZAK0
         tvgjRG75pAMstxKB3cvaOppvECT1YU0pW9RjftEintEsdTMn2GIxwEzM6XIfENCQpiZN
         peVwPMZEMFDhdoQmPLPQgCuXTwvbUmsg/IEJeuFEJW5T+UKMAYDOPcpCF3Usk/63L8nV
         YmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=o0SYpITCq+PSSMeMLJ7UG8q5bBiF679tRTj0DAn+kqA=;
        b=kwoRt3Q6a3y2XjSp9BKx+FL87M6TDjdQOjwQ9tk6e7jLn5Z8j1Y2rqB846Cgb+2Yca
         8xzGU0ncLvHlxDi82y0yBZE/3vHoNd8rehZs7txAOnSL72EWHWVec25mHXrYcu3dkwL5
         vsJTaWnHDXJESY5WX8SYD9q+DiZyQghDPbEmUVxOmay688baR7epdCgnq+U5OQMYf4bu
         +rhvQHw4neTGYQR438ZZk+KTT3jT4qt4gus370sZI6OUt2pRgya99PbgpSL/f+5Uyata
         +nZp955paU5d3fouZlsyaN9DLNta4Pfgi1JYfMP65H9zO2sgcwWSsBNr8F1k2uHQhm8F
         QPlg==
X-Gm-Message-State: APjAAAXXcLZo3TKPLyOAm/dB/FCSXK0VRzXH65TqtPQa9lRXTBshGVTW
        70y//ZCrVpshsAA/K1uYO7PNYQ==
X-Google-Smtp-Source: APXvYqxhlo8qNE3ee7BRqnzUQ2Znwnm3uJhsqJuW91+iZpwN4esqHAT6uexjF+TueWheZMvex2/uPQ==
X-Received: by 2002:a63:714a:: with SMTP id b10mr852387pgn.25.1566947838921;
        Tue, 27 Aug 2019 16:17:18 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id o67sm397358pfb.39.2019.08.27.16.17.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 16:17:18 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 02/18] ionic: Add hardware init and device
 commands
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190826213339.56909-1-snelson@pensando.io>
 <20190826213339.56909-3-snelson@pensando.io> <20190827022628.GD13411@lunn.ch>
 <ab2d6525-e1e1-ef87-7150-dabfaee5b6ff@pensando.io>
 <20190827195017.GR2168@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <fab6e4d9-ba9f-b64e-4fc2-bae176026467@pensando.io>
Date:   Tue, 27 Aug 2019 16:17:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827195017.GR2168@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/19 12:50 PM, Andrew Lunn wrote:
> On Tue, Aug 27, 2019 at 10:39:20AM -0700, Shannon Nelson wrote:
>> On 8/26/19 7:26 PM, Andrew Lunn wrote:
>>> On Mon, Aug 26, 2019 at 02:33:23PM -0700, Shannon Nelson wrote:
>>>> +void ionic_debugfs_add_dev(struct ionic *ionic)
>>>> +{
>>>> +	struct dentry *dentry;
>>>> +
>>>> +	dentry = debugfs_create_dir(ionic_bus_info(ionic), ionic_dir);
>>>> +	if (IS_ERR_OR_NULL(dentry))
>>>> +		return;
>>>> +
>>>> +	ionic->dentry = dentry;
>>>> +}
>>> Hi Shannon
>>>
>>> There was recently a big patchset from GregKH which removed all error
>>> checking from drivers calling debugfs calls. I'm pretty sure you don't
>>> need this check here.
>> With this check I end up either with a valid dentry value or NULL in
>> ionic->dentry.  Without this check I possibly get an error value in
>> ionic->dentry, which can get used later as the parent dentry to try to make
>> a new debugfs node.
> Hi Shannon
>
> What you should find is that every debugfs function will have
> something like:
>
> 	if (IS_ERR(dentry))
> 	   return dentry;
> or
> 	if (IS_ERR(parent))
> 	   return parent;
>
> If you know of a API which is missing such protection, i'm sure GregKH
> would like to know. Especially since he just ripped all such
> protection in driver out. Meaning he just broken some drivers if such
> IS_ERR() calls are missing in the debugfs core.
>
Ah, here's the confusion: there's a start_creating() in the tracefs as 
well as in the debugfs, and the tracefs code doesn't have all of those 
checks.

sln


