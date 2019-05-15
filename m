Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 367A51F8C5
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfEOQiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:38:50 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45017 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfEOQit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 12:38:49 -0400
Received: by mail-pl1-f195.google.com with SMTP id c5so121725pll.11
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 09:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=lfG1t0VAee2putTrZT/9Jlc/S+MzpiLSkLc5DjE/920=;
        b=qj20StoL57/8mJ8YE8jAnPCzydu+z1vMQPpLRFNsWtIBgQzmVzpUwixhMvC+Mljev9
         uTA0Di0+aSe6leiDjPtnz1jknmBk555YLLfgNOizFBBERcfC+pEVKIai0A9quWdMUjJG
         4SFJpds1GQJ4ps8WGQhytrprku9VHl8WJGf+glFkXTHE1XsTyDbmnwsmH4zcUuXszUkg
         leL3i1pow8MNjWF62aLlQNkVi8RJougikiS8UprkDV1a+SJevVwOceu+zU2eYJ1xYnTK
         knnUlorFCS1nYzaThrzHXuY/Lo8dqq5MIgacFOczTY4xVGF/RQiE0O0MzhwOYSyPZA0p
         0CvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=lfG1t0VAee2putTrZT/9Jlc/S+MzpiLSkLc5DjE/920=;
        b=BzX2MIgWhlVj1LpDbetYa5Tw6IEzuHHLhpHCENoF3NjxAzbepiFmLllM3/UuQvmxQu
         w8HZyDJ5vqQSFwyqgxbhgISmMMtgtQMUdF00Ajf1vfPAt7tw9IPd093qkV1qLRD+2998
         2cvmFROoIIi5TqeuvNtmyFpEEhChuJ6DQG00tpWqGG1TCxq+faTq5XjnmwGWkCqJkjD2
         tPWKxcQQGtuhv41YmW8GUzNdIji/+szNSgLb/y8LR6TRPOUhBhnGpZEUA1pFIPV3l3n7
         F9KQ1c9KEjlUs0EGkf6MGgxyy5gHO/8ceW307NSTb/G9sWjI+zG/6hvLHj17J44iTGDw
         gG6A==
X-Gm-Message-State: APjAAAVAxdaWV6K2jJKfVi0J2g5sb3fMMkChXS6FFMiabNRVK9Lrh2B2
        FORCnllKZRlAUX886mSFYNE=
X-Google-Smtp-Source: APXvYqzEUTsy3Rf7aFfxBBniuPBsDA2wwD6Fa+PNdVLXJEz8cxK2WAWS7RBw8WebkLFG/P/lna4G1Q==
X-Received: by 2002:a17:902:2907:: with SMTP id g7mr20276798plb.114.1557938329050;
        Wed, 15 May 2019 09:38:49 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:81dc:8ee9:edb2:6ea? ([2601:282:800:fd80:81dc:8ee9:edb2:6ea])
        by smtp.googlemail.com with ESMTPSA id b23sm3418500pfi.6.2019.05.15.09.38.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 09:38:47 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: fix src addr routing with the exception table
From:   David Ahern <dsahern@gmail.com>
To:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        Eric Dumazet <edumazet@google.com>
References: <20190515004610.102519-1-tracywwnj@gmail.com>
 <fdded637-fd19-bcab-87aa-b71ca8158735@gmail.com>
Message-ID: <95d844f2-1be2-83b9-1910-e90ad3d2b28d@gmail.com>
Date:   Wed, 15 May 2019 10:38:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <fdded637-fd19-bcab-87aa-b71ca8158735@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------AB10A12D913C998F9232231B"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------AB10A12D913C998F9232231B
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 5/15/19 9:56 AM, David Ahern wrote:
> You can add a 'cache' hook to ip/iproute.c to delete the cached routes
> and verify that it works. I seem to have misplaced my patch to do it.

found it.

--------------AB10A12D913C998F9232231B
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-route-Add-cache-keyword-to-iproute_modify.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-route-Add-cache-keyword-to-iproute_modify.patch"

RnJvbSA3YTMyODc1M2E5MzMyMWEwN2E1MjI4ZmIzMmVkODgxZDgyZDdhNTM3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5jb20+
CkRhdGU6IE1vbiwgNiBNYXkgMjAxOSAwODowOTowMSAtMDcwMApTdWJqZWN0OiBbUEFUQ0gg
aXByb3V0ZTItbmV4dF0gcm91dGU6IEFkZCBjYWNoZSBrZXl3b3JkIHRvIGlwcm91dGVfbW9k
aWZ5CgpLZXJuZWwgc3VwcG9ydHMgZGVsZXRpbmcgY2FjaGVkIHJvdXRlcyAoZS5nLiwgZXhj
ZXB0aW9ucykuIEFkZCBjYWNoZQprZXl3b3JkIHRvIGlwcm91dGVfbW9kaWZ5IHRvIHNldCBS
VE1fRl9DTE9ORUQgaW4gdGhlIHJlcXVlc3QuCgpTaWduZWQtb2ZmLWJ5OiBEYXZpZCBBaGVy
biA8ZHNhaGVybkBnbWFpbC5jb20+Ci0tLQogaXAvaXByb3V0ZS5jIHwgNCArKystCiAxIGZp
bGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0
IGEvaXAvaXByb3V0ZS5jIGIvaXAvaXByb3V0ZS5jCmluZGV4IDJiM2RjYzVkYmQ1My4uZDdh
ODEyYTM5MDQ3IDEwMDY0NAotLS0gYS9pcC9pcHJvdXRlLmMKKysrIGIvaXAvaXByb3V0ZS5j
CkBAIC03NCw3ICs3NCw3IEBAIHN0YXRpYyB2b2lkIHVzYWdlKHZvaWQpCiAJCSIgICAgICAg
aXAgcm91dGUgeyBhZGQgfCBkZWwgfCBjaGFuZ2UgfCBhcHBlbmQgfCByZXBsYWNlIH0gUk9V
VEVcbiIKIAkJIlNFTEVDVE9SIDo9IFsgcm9vdCBQUkVGSVggXSBbIG1hdGNoIFBSRUZJWCBd
IFsgZXhhY3QgUFJFRklYIF1cbiIKIAkJIiAgICAgICAgICAgIFsgdGFibGUgVEFCTEVfSUQg
XSBbIHZyZiBOQU1FIF0gWyBwcm90byBSVFBST1RPIF1cbiIKLQkJIiAgICAgICAgICAgIFsg
dHlwZSBUWVBFIF0gWyBzY29wZSBTQ09QRSBdXG4iCisJCSIgICAgICAgICAgICBbIHR5cGUg
VFlQRSBdIFsgc2NvcGUgU0NPUEUgXSBbIGNhY2hlIF1cbiIKIAkJIlJPVVRFIDo9IE5PREVf
U1BFQyBbIElORk9fU1BFQyBdXG4iCiAJCSJOT0RFX1NQRUMgOj0gWyBUWVBFIF0gUFJFRklY
IFsgdG9zIFRPUyBdXG4iCiAJCSIgICAgICAgICAgICAgWyB0YWJsZSBUQUJMRV9JRCBdIFsg
cHJvdG8gUlRQUk9UTyBdXG4iCkBAIC0xNDQ0LDYgKzE0NDQsOCBAQCBzdGF0aWMgaW50IGlw
cm91dGVfbW9kaWZ5KGludCBjbWQsIHVuc2lnbmVkIGludCBmbGFncywgaW50IGFyZ2MsIGNo
YXIgKiphcmd2KQogCQkJaWYgKGZhc3RvcGVuX25vX2Nvb2tpZSAhPSAxICYmIGZhc3RvcGVu
X25vX2Nvb2tpZSAhPSAwKQogCQkJCWludmFyZygiXCJmYXN0b3Blbl9ub19jb29raWVcIiB2
YWx1ZSBzaG91bGQgYmUgMCBvciAxXG4iLCAqYXJndik7CiAJCQlydGFfYWRkYXR0cjMyKG14
cnRhLCBzaXplb2YobXhidWYpLCBSVEFYX0ZBU1RPUEVOX05PX0NPT0tJRSwgZmFzdG9wZW5f
bm9fY29va2llKTsKKwkJfSBlbHNlIGlmICghc3RyY21wKCphcmd2LCAiY2FjaGUiKSkgewor
CQkJcmVxLnIucnRtX2ZsYWdzIHw9IFJUTV9GX0NMT05FRDsKIAkJfSBlbHNlIHsKIAkJCWlu
dCB0eXBlOwogCQkJaW5ldF9wcmVmaXggZHN0OwotLSAKMi4xMS4wCgo=
--------------AB10A12D913C998F9232231B--
