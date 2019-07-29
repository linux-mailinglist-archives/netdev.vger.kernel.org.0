Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E73B79C6E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 00:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfG2W2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 18:28:05 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34858 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728907AbfG2W2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 18:28:05 -0400
Received: by mail-pf1-f193.google.com with SMTP id u14so28748068pfn.2
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 15:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nbzdoFMM7sd4gL1KLFZ+vAy/meUEk723+2o2js0HpH0=;
        b=s2OxtMPuoqIE1vihDqEIRXWhLwKRWB2bMTY4/nq7nIWrg8ILMg53d/M1gkoR4lJalM
         G05fA9AUJnnTSoKLTJuOKelODYKzc1lHuuOLsXjKR98q/Pr5IDWd10kY5O8edR+MBfEw
         OjNuxRYEpT5EZXhHUVGRUjOU6WHHoRcAjQ34VVjM935WJTX83NgQjHR7PDeCX/48a4VL
         d1kyd9mqgo4YbUQnN7Ox0lWQb56faAqN005b8mFFDvfKGt3ItpSrAKQzF7rhIQL2l6TE
         MG4CYfL/NsoahOeTdY9RBG+G706SqgZ2OCUwNk1laR12qkohAS0rbg5qKE0M8ytW9E9y
         qAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nbzdoFMM7sd4gL1KLFZ+vAy/meUEk723+2o2js0HpH0=;
        b=ECm7pOqMEAUw/LcJdKqDksfMHv1xE/nfyYFwf8irde+WwtsM7ywDcsjRyqTwbsT+PS
         tXNDWkWhl9T8+b9MoSXM+dNAaFbXd4MfcULj6EOgLQvcdmMujW+65LJ2rdg4cPU9I7mA
         SXvfWfaCg8BXDqqoVY/EWifXBafVwLhbVp27JIBw+9gwvxxhV9T6LZlXbQORPDhxfurO
         /IIhdVTelW4YFLd96z18562XnKbMct7m5291otepbqF2xCbLITdw45luucfoelEURvMn
         v4gHfjJV/Wrew50SXMJsnlGh60Yc3Hkt7TsqWeOlSmpvMDNFznWXo76mCI8biesnySq6
         0/VQ==
X-Gm-Message-State: APjAAAV2urHvISRgAhEynseb8gTTFYf9KfXNaiROxNcLLG2GDTLTjdlg
        z/Ui0ocLcRV1IzUQIvaDZhC40f/y
X-Google-Smtp-Source: APXvYqyN6UPTX5JSLRlhP7rHwoNy8Mreb6wCNm5Jk9l70C90ldwchkj5VSXBH+qrsLXGxoDb0slj/w==
X-Received: by 2002:a63:2ec9:: with SMTP id u192mr103890824pgu.16.1564439284546;
        Mon, 29 Jul 2019 15:28:04 -0700 (PDT)
Received: from [172.27.227.219] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id r13sm89803355pfr.25.2019.07.29.15.28.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 15:28:03 -0700 (PDT)
Subject: Re: [PATCH net] net: ipv6: Fix a bug in ndisc_send_ns when netdev
 only has a global address
To:     David Miller <davem@davemloft.net>, suyj.fnst@cn.fujitsu.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
References: <1564368591-42301-1-git-send-email-suyj.fnst@cn.fujitsu.com>
 <20190729.141752.457438545178811941.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <12422738-99ed-16ba-ba18-9e3867dbfed9@gmail.com>
Date:   Mon, 29 Jul 2019 16:28:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190729.141752.457438545178811941.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/19 3:17 PM, David Miller wrote:
> David, can you take a quick look at this?

will do. I'll get back to you by tomorrow.
