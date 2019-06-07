Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A7839253
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 18:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730976AbfFGQiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 12:38:46 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41427 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729953AbfFGQip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 12:38:45 -0400
Received: by mail-lf1-f67.google.com with SMTP id 136so2096069lfa.8
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 09:38:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M6fQOpOxxm854dFRSslkO9Ys9N5P4jge8tnN2qc8Wgc=;
        b=l45SAvBhdC11dyBsPTMI7kQiF9vJGGldYmPW9k0gIYg4qBqUTXHvhWizi6AGn4+XYX
         QVA0VAkqOVRqJl+f3PhDHu10pcqKJiVFSzRUG3nwqCBzzy99WlFEsafjXHEO92u/BW8r
         F1CUDNXa9iEPKlisgOW44lvlzhb7DtvuG0CDhBpMzyldMxh4K89Iv7B+3eWKoCO4zqZQ
         MihVN65B6wHW8SpMgXC3JvXacs2oOWbc2IavRFtrOze4Qe6p9KmDJtc5y5IHBJ1DcktY
         bA9sOMEpiUmu5OvrgPuG7yQ082S2T0fjkR/slvBuMMwEBAiRtGHcmOmZnTeU3VhPmoRX
         ZDKg==
X-Gm-Message-State: APjAAAXur4caxlsU6liUx9nS+K4n4OTgyhrO3CdHdtylIDClMhitZ+1Q
        KPRGnVnZRVdfe3h54U6WHOQ2Jy+wHff60kLCHADbfRdY
X-Google-Smtp-Source: APXvYqxwgQy8B+m8kjJAc4K9rIu5y1GBaWUlef7tuO7Gh0Z0AmQVGrKX+J6CXStKppOMf28K5+F4ULg0SZVUKBLAfTs=
X-Received: by 2002:a19:e308:: with SMTP id a8mr26359732lfh.69.1559925523955;
 Fri, 07 Jun 2019 09:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190607101313.8561-1-mcroce@redhat.com> <20190607082517.5ebcceca@hermes.lan>
In-Reply-To: <20190607082517.5ebcceca@hermes.lan>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 7 Jun 2019 18:38:07 +0200
Message-ID: <CAGnkfhxHvJicm7u1YtVxVSVxQbb2+xrxKdU-TZ8fGTBcz7vpQA@mail.gmail.com>
Subject: Re: [PATCH iproute2] ip: reset netns after each command in batch mode
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Andrea Claudi <aclaudi@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 7, 2019 at 5:25 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri,  7 Jun 2019 12:13:13 +0200
> Matteo Croce <mcroce@redhat.com> wrote:
>
> > +void netns_restore(void)
> > +{
> > +     if (saved_netns != -1) {
>
> If saved_netns is -1 then it is a program bug becase
> no save was done? then do something?
>

saved_netns can be -1 if you execute a batch which doesn't never
change the current netns, e.g: only link, addr, route etc.
In this case netns_restore() will do nothing as there is nothing to restore

> > +             if (!setns(saved_netns, CLONE_NEWNET)) {
> > +                     close(saved_netns);
> > +                     saved_netns = -1;
> > +             } else {
> > +                     perror("setns");
>
> If you are going to look for errors. then you need to either
> return the error or cause the program to exit.
> You don't want later commands in the batch to be applied
> to wrong namespace.

Right. A failure in restoring a saved netns means that something bad
happened, so better stop.

Regards,

--
Matteo Croce
per aspera ad upstream
