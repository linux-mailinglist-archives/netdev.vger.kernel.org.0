Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBEAEB9AA
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387475AbfJaWY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:24:58 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43351 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387463AbfJaWY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 18:24:58 -0400
Received: by mail-lf1-f67.google.com with SMTP id j5so5887420lfh.10
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 15:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ORkqg8jrCk99CbRhXtrcXymZe6o7nmpqtAPr7747lS8=;
        b=AD/gZZ1Cpjbeqlwfl+u10wNGTldCiw330eGBQ1fshVKctYYDKteTuKDivIB1FUE1FW
         NrKb8RTOhD3IfZmE6+kSKNGn6Vo2NXnakjLzZ0r1MMjTtJ/OzVRw7ohloDnZfD4kRPqC
         qnmvt7mV23Tl60X47NEoJjBg6wg9MGohmgttpK/im/fMVZs03RVGZcEcv/eQDlT54W64
         HnTxis86hAnWMaI2aed7c8/+ZMmfMn/AJivbvBKumPCBs62+RfNNIQ7284+58+1ipzqW
         hNSZ+fYGxx2/aDovqaRC0gykyMrLDzDkt1XoSNZLKkW5oqROLJm+Yztga0AG8Enjk5TF
         Y5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ORkqg8jrCk99CbRhXtrcXymZe6o7nmpqtAPr7747lS8=;
        b=ZP7whGQIUouTroXFkmSqMUIV1seTfyuxSoy5XTcPs1YniIH3mQdZ/jTe/drkWuMQFm
         iKbMCRVBpFT/JldVr9TDGuLvr8RmnRGvQNYcbP4kEC3rfAMisRbdmbu0SBp2nKRDdpGe
         /uLiDLyBkmSRfzAG6oLFLcpaPzkv7TFCCqLkpQLjce7J4LQzF9Q3UVXMmKaV1afwoN7+
         4nvuW+/lZO3Qr0ydW1WVeAYujRHjh9baqzmeKUN/yaVsdiMHoK8tJYlm1+6Xz69LBqH4
         SJ33phU3QSjDptwlJLt4IZp9mT4t8UvykjRLNU72YgU/C5NxG87U8S7IFahMu/ejhh8L
         A5Pg==
X-Gm-Message-State: APjAAAVrVqwRKIiDgvCtU55e3ma55bGTusr4mUmjFLTPCX55YHetiMVF
        FK+rUZfgtuA7687Uf8Ygt0fAjA==
X-Google-Smtp-Source: APXvYqxNDxzC9Op1/RduXp77CMkaMX5QPJzNtAPa2NzrUsN+xGhvvNluCpj+CHNKMwn1tQ+RgNy+eA==
X-Received: by 2002:ac2:48b5:: with SMTP id u21mr5259536lfg.75.1572560693859;
        Thu, 31 Oct 2019 15:24:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g3sm1699096ljj.59.2019.10.31.15.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 15:24:53 -0700 (PDT)
Date:   Thu, 31 Oct 2019 15:24:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, borisp@mellanox.com,
        aviadye@mellanox.com, daniel@iogearbox.net,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@kernel.org>,
        herbert@gondor.apana.org.au, glider@google.com,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH net] net/tls: fix sk_msg trim on fallback to copy mode
Message-ID: <20191031152444.773c183b@cakuba.netronome.com>
In-Reply-To: <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
        <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 15:05:53 -0700, John Fastabend wrote:
> Jakub Kicinski wrote:
> > sk_msg_trim() tries to only update curr pointer if it falls into
> > the trimmed region. The logic, however, does not take into the
> > account pointer wrapping that sk_msg_iter_var_prev() does.
> > This means that when the message was trimmed completely, the new
> > curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
> > neither smaller than any other value, nor would it actually be
> > correct.
> > 
> > Special case the trimming to 0 length a little bit.
> > 
> > This bug caused the TLS code to not copy all of the message, if
> > zero copy filled in fewer sg entries than memcopy would need.
> > 
> > Big thanks to Alexander Potapenko for the non-KMSAN reproducer.
> > 
> > Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> > Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
> > Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > ---
> > Daniel, John, does this look okay?  
> 
> Thanks for the second ping!

No problem, I was worried the patch got categorized as TLS and therefore
lower prio ;)

> > CC: Eric Biggers <ebiggers@kernel.org>
> > CC: herbert@gondor.apana.org.au
> > CC: glider@google.com
> > CC: linux-crypto@vger.kernel.org
> > 
> >  net/core/skmsg.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index cf390e0aa73d..c42c145216b1 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -276,7 +276,10 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
> >  	 * However trimed data that has not yet been used in a copy op
> >  	 * does not require an update.
> >  	 */
> > -	if (msg->sg.curr >= i) {
> > +	if (!msg->sg.size) {
> > +		msg->sg.curr = 0;
> > +		msg->sg.copybreak = 0;
> > +	} else if (msg->sg.curr >= i) {
> >  		msg->sg.curr = i;
> >  		msg->sg.copybreak = msg->sg.data[i].length;
> >  	}
> > --   
> 
> 
> Its actually not sufficient. We can't directly do comparisons against curr
> like this. msg->sg is a ring buffer so we have to be careful for these
> types of comparisons.
> 
> Examples hopefully help explian. Consider the case with a ring layout on
> entering sk_msg_trim,
> 
>    0 1 2                              N = MAX_MSG_FRAGS
>   |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>        ^       ^         ^
>        curr    end       start
> 
> Start trimming from end
> 
>    0 1 2                              N = MAX_MSG_FRAGS
>   |X|X|X|...|X|X|_|...|_|_|i|X|....|X|X|
>        ^       ^         ^
>        curr    end       start
> 
> We trim backwards through ring with sk_msg_iter_var_prev(). And its
> possible to end with the result of above where 'i' is greater than curr
> and greater than start leaving scatterlist elements so size != 0.
> 
>     i > curr && i > start && sg.size != 0
> 
> but we wont catch it with this condition
> 
>     if (msg->sg.curr >= i)
> 
> So we won't reset curr and copybreak so we have a potential issue now
> where curr is pointing at data that has been trimmed.

I see, that makes sense and explains some of the complexity!

Perhaps the simplest way to go would be to adjust the curr as we go
then? The comparison logic could get a little hairy. So like this:

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cf390e0aa73d..c2b0f9cb589c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -261,25 +261,29 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
        msg->sg.size = len;
        while (msg->sg.data[i].length &&
               trim >= msg->sg.data[i].length) {
+               bool move_curr = msg->sg.curr == i;
+
                trim -= msg->sg.data[i].length;
                sk_msg_free_elem(sk, msg, i, true);
                sk_msg_iter_var_prev(i);
+               if (move_curr) {
+                       msg->sg.curr = i;
+                       msg->sg.copybreak = msg->sg.data[i].length;
+               }
                if (!trim)
                        goto out;
        }
 
        msg->sg.data[i].length -= trim;
        sk_mem_uncharge(sk, trim);
-out:
        /* If we trim data before curr pointer update copybreak and current
         * so that any future copy operations start at new copy location.
         * However trimed data that has not yet been used in a copy op
         * does not require an update.
         */
-       if (msg->sg.curr >= i) {
-               msg->sg.curr = i;
+       if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
                msg->sg.copybreak = msg->sg.data[i].length;
-       }
+out:
        sk_msg_iter_var_next(i);
        msg->sg.end = i;
 }

> I'll put together a fix but the correct thing to do here is a proper
> ring greater than op which is not what we have there. Although, your patch
> is also really a good one to have because reseting curr = 0 and
> copybreak = 0 when possible keeps the ring from being fragmented which
> avoids chaining when we push scatterlists down to crypto layer. So for
> your patch,
> 
> Acked-By: John Fastabend <john.fastabend@gmail.com>
> 
> If it should go to net or net-next I think is probably up for debate
> 
> Nice catch!!! Can you send me the reproducer?

I was using the repro from the syzbot report:

https://syzkaller.appspot.com/bug?extid=6f50c99e8f6194bf363f

plus this hack from Alexander to avoid the need for KMSAN:

https://lkml.kernel.org/linux-crypto/CAG_fn=UGCoDk04tL2vB981JmXgo6+-RUPmrTa3dSsK5UbZaTjA@mail.gmail.com/
