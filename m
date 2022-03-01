Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E842D4C88EE
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiCAKHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiCAKHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:07:00 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACB25DE63
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 02:06:17 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nOzOZ-00059h-BW; Tue, 01 Mar 2022 11:06:15 +0100
Message-ID: <792b4bc3-af13-483f-0886-ea56da862172@leemhuis.info>
Date:   Tue, 1 Mar 2022 11:06:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Regression are sometimes merged slowly, maybe optimize the
 downstream interaction?
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <37349299-c47b-1f67-2229-78ae9b9b4488@leemhuis.info>
 <20220228094626.7e116e2c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220228094626.7e116e2c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1646129178;ae06060f;
X-HE-SMSGID: 1nOzOZ-00059h-BW
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.02.22 18:46, Jakub Kicinski wrote:
> On Mon, 28 Feb 2022 14:45:47 +0100 Thorsten Leemhuis wrote:
>> I was wondering if you and your downstream maintainers could consider
>> slightly optimizing your working habits to get regression fixes from
>> downstream git repos a bit quicker into mainline. A slightly different
>> timing afaics might already help a lot; or some timing optimizations in
>> the interaction with downstream maintainers.
>>
>> I ask, because in my regression tracking work I noticed that quite a few
>> regression fixes take a long time towards mainline when they need to go
>> through net.git; that imho is especially bad for regressions caused by
>> commits in earlier development cycles, as they can only be fixed in new
>> stable releases after the fix was mainlined.
>>
>> Often the fixes progress slowly due to the habits of the downstream
>> maintainers -- some for example are imho not asking you often enough to
>> pull fixes. I guess that might need to be discussed down the road as
>> well, but there is something else that imho needs to be addressed first.
>>
>> At least from the outside it often looks like bad timing is the reason
>> why some fixes take quite long journey to mainline. Take for example the
>> latest pull requests for bluetooth and ipsec:
>>
>> https://lore.kernel.org/netdev/20220224210838.197787-1-luiz.dentz@gmail.com/
>> https://lore.kernel.org/netdev/20220225074733.118664-1-steffen.klassert@secunet.com/
> 
> Yeah, we also narrowly missed the BPF pr a week back :/
> Or should I say BPF pr missed the net pr..

:-D

I guess things like that will always happen and that is nothing to loose
sleep over -- but maybe with some optimizations we can reduce the number
of times they happen.

>> One is from Thursday, the other from early Friday; both contain fixes
>> for regressions in earlier mainline releases that afaics need to get
>> backported to stable and longterm releases to finally get the regression
>> erased from this world. The ipsec fix has been in -next already for a
>> while, the bluetooth fix afaics wasn't.
>>
>> Sadly, both patch sets missed rc6 as Jakub already had sent his pull
>> request to Linus on Thursday:
>> https://lore.kernel.org/all/20220224195305.1584666-1-kuba@kernel.org/
>>
>> This is not the first time I noticed such bad timing. That made me
>> wonder: would it be possible for you to optimize the workflow here?
>> Maybe a simple advice to downstream maintainers could do the trick, e.g.
>> "ideally sent pull request by Friday morning[some timezone] at the
>> latest, as then the net maintainers can review, merge, and sent them
>> onwards to Linus in a pull request later that day".
>
> These are fair complaints. We've been sending PRs with fixes every
> Thursday for, I'd say, a year or so now. If the sub-tree PR is posted 
> by Wednesday it will definitely make the cut. Either folks don't know 
> this or they want changes to sit in the networking tree for a couple
> of days? Hm.

Just wondering: some (most?) of those sub-trees afaics have a stable
branch included in -next, so would sitting in the networking tree
actually make much of a difference for them?

>> FWIW, I don't know anything about the inner working of your subsystem,
>> if you need more time to review or process merge requests from
>> downstream maintainers the "Friday morning" obviously needs to be adjusted.
>>
>> Or is there something like that already and the timing just has been bad
>> a few times when I looked closer?
> 
> I think it's a particularly unfortunate time with a few "missed prs"
> in a short span of time. When Dave was handling all the prs he used
> to decide the timing based on contents of the tree, maybe that's 
> a better model for prioritizing fixes getting to Linus, but I lack 
> the skills necessary to make such calls.
> 
> I'll try to advertise the Wednesday rule more, 

Thx

> although creating
> deadlines has proven to lead to rushed work. Which IMHO is much 
> worse :(

Don't call it a deadline then. :-D But joking aside, I know what you
mean, and yes, that is a reasonable concern.

Maybe one thing could help in here sometimes: if sub-tree maintainers
with your permission ask Linus to pick up a single patch directly from a
repo or a list, *if* there is a good reason to get a fix quickly merged.

> [...]
> Anyway, thanks for raising the issue, and please keep us posted on how
> things look from your perspective. It's a balancing act, it'd be great
> if we can improve things over time without sudden changes.

Yeah, it's definitely a balancing act.

And as you asked for how things look from here, let me get back to the
one issue I already briefly in my mail. To repeat a quote from above:

>> Often the fixes progress slowly due to the habits of the downstream
>> maintainers -- some for example are imho not asking you often enough to
>> pull fixes. I guess that might need to be discussed down the road as
>> well, but there is something else that imho needs to be addressed first.

To give an example, but fwiw: that is in no way special, I've seen
similar turn of events for a few other regressions fixes in sub-tree of
net, so it really is just meant as an example for a general issue (sorry
Steffen).

See this fix:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=master&id=a6d95c5a628a09be129f25d5663a7e9db8261f51

The regression was introduced in 5.14-rc1 and the fix was posted on
2022-01-14, so 46 days ago.

Jiri, who provided the patch, actually wrote "being a regression maybe
we want the fastest track possible" here:
https://lore.kernel.org/netdev/20220119091233.pzqdlzpcyicjavk5@dwarf.suse.cz/

Steffen applied the fix 27 days ago:
https://lore.kernel.org/netdev/20220201064639.GS1223722@gauss3.secunet.de/

Three days later it was in -next. After some time I asked when it will
get merged, to which Steffen replied "It will be merged with the next
pull request for the ipsec tree that will happen likely next week."
https://lore.kernel.org/regressions/20220216110252.GJ17351@gauss3.secunet.de/

He sent that PR on Friday, so the fix will finally be merged to mainline
on Thursday. If Greg immediately picks it up after -rc7 the issue can
finally get fixed in 5.15.y and 5.16.y mid next week -- more than 50
days after the patch for the regression was posted.

Again: I had similar issues with the bluetooth maintainers and the
wireless maintainers (the latter already seem to have slightly changed
their workflow to improve things).

Anyway: sure, reviewing takes time and ideally every fix is in -next for
a while, but I think 50 days is way too long.

Maybe sub-tree maintainers should send PRs more often? Or just tell you
to directly pick up a fix once they reviewed them to avoid the sub-tree
and a merge commits that brings in just one patch?

Fwiw, situations like that in the end let to the creation of a docs
patch that is en-route to 5.18:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=d2b40ba2cce207ecea8a740f71e113f03cc75fd5

To quote:

> +Prioritize work on fixing regressions
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +You should fix any reported regression as quickly as possible, to provide
> +affected users with a solution in a timely manner and prevent more users from
> +running into the issue; nevertheless developers need to take enough time and
> +care to ensure regression fixes do not cause additional damage.
> +
> +In the end though, developers should give their best to prevent users from
> +running into situations where a regression leaves them only three options: "run
> +a kernel with a regression that seriously impacts usage", "continue running an
> +outdated and thus potentially insecure kernel version for more than two weeks
> +after a regression's culprit was identified", and "downgrade to a still
> +supported kernel series that lack required features".
> +
> +How to realize this depends a lot on the situation. Here are a few rules of
> +thumb for you, in order or importance:
> +
> + * Prioritize work on handling regression reports and fixing regression over all
> +   other Linux kernel work, unless the latter concerns acute security issues or
> +   bugs causing data loss or damage.
> +
> + * Always consider reverting the culprit commits and reapplying them later
> +   together with necessary fixes, as this might be the least dangerous and
> +   quickest way to fix a regression.
> +
> + * Developers should handle regressions in all supported kernel series, but are
> +   free to delegate the work to the stable team, if the issue probably at no
> +   point in time occurred with mainline.
> +
> + * Try to resolve any regressions introduced in the current development before
> +   its end. If you fear a fix might be too risky to apply only days before a new
> +   mainline release, let Linus decide: submit the fix separately to him as soon
> +   as possible with the explanation of the situation. He then can make a call
> +   and postpone the release if necessary, for example if multiple such changes
> +   show up in his inbox.
> +
> + * Address regressions in stable, longterm, or proper mainline releases with
> +   more urgency than regressions in mainline pre-releases. That changes after
> +   the release of the fifth pre-release, aka "-rc5": mainline then becomes as
> +   important, to ensure all the improvements and fixes are ideally tested
> +   together for at least one week before Linus releases a new mainline version.
> +
> + * Fix regressions within two or three days, if they are critical for some
> +   reason -- for example, if the issue is likely to affect many users of the
> +   kernel series in question on all or certain architectures. Note, this
> +   includes mainline, as issues like compile errors otherwise might prevent many
> +   testers or continuous integration systems from testing the series.
> +
> + * Aim to fix regressions within one week after the culprit was identified, if
> +   the issue was introduced in either:
> +
> +    * a recent stable/longterm release
> +
> +    * the development cycle of the latest proper mainline release
> +
> +   In the latter case (say Linux v5.14), try to address regressions even
> +   quicker, if the stable series for the predecessor (v5.13) will be abandoned
> +   soon or already was stamped "End-of-Life" (EOL) -- this usually happens about
> +   three to four weeks after a new mainline release.
> +
> + * Try to fix all other regressions within two weeks after the culprit was
> +   found. Two or three additional weeks are acceptable for performance
> +   regressions and other issues which are annoying, but don't prevent anyone
> +   from running Linux (unless it's an issue in the current development cycle,
> +   as those should ideally be addressed before the release). A few weeks in
> +   total are acceptable if a regression can only be fixed with a risky change
> +   and at the same time is affecting only a few users; as much time is
> +   also okay if the regression is already present in the second newest longterm
> +   kernel series.
> +
> +Note: The aforementioned time frames for resolving regressions are meant to
> +include getting the fix tested, reviewed, and merged into mainline, ideally with
> +the fix being in linux-next at least briefly. This leads to delays you need to
> +account for.
> +
> +Subsystem maintainers are expected to assist in reaching those periods by doing
> +timely reviews and quick handling of accepted patches. They thus might have to
> +send git-pull requests earlier or more often than usual; depending on the fix,
> +it might even be acceptable to skip testing in linux-next. Especially fixes for
> +regressions in stable and longterm kernels need to be handled quickly, as fixes
> +need to be merged in mainline before they can be backported to older series.
> +

The patch description explains some of the reasons for this. Linus was
CCed on this, sadly didn't state if this is actually what he expects. So
it still needs to be proven if this holds in the field.

Ciao, Thorsten
