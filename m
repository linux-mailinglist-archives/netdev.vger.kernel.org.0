Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7986B1B522E
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgDWB6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:58:11 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64651 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgDWB6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 21:58:11 -0400
Received: from fsav106.sakura.ne.jp (fsav106.sakura.ne.jp [27.133.134.233])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 03N1vmAc011808;
        Thu, 23 Apr 2020 10:57:48 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav106.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav106.sakura.ne.jp);
 Thu, 23 Apr 2020 10:57:48 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav106.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 03N1vmSN011805
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Thu, 23 Apr 2020 10:57:48 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: WARNING: locking bug in tomoyo_supervisor
To:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc:     syzbot <syzbot+1c36440b364ea3774701@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Network Development <netdev@vger.kernel.org>,
        James Chapman <jchapman@katalix.com>,
        Petr Mladek <pmladek@suse.com>
References: <000000000000a475ac05a36fa01e@google.com>
 <5b71a079-54bb-57a0-360d-33fce141504f@i-love.sakura.ne.jp>
 <20200423015008.GA246741@jagdpanzerIV.localdomain>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <5e192ca2-3b24-0b45-fc13-51feec43c216@i-love.sakura.ne.jp>
Date:   Thu, 23 Apr 2020 10:57:47 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423015008.GA246741@jagdpanzerIV.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/04/23 10:50, Sergey Senozhatsky wrote:
> On (20/04/17 13:37), Tetsuo Handa wrote:
>> On 2020/04/17 7:05, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following crash on:
>>>
>>> HEAD commit:    4f8a3cc1 Merge tag 'x86-urgent-2020-04-12' of git://git.ke..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1599027de00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3bfbde87e8e65624
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=1c36440b364ea3774701
>>> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150733cde00000
>>
>> This seems to be a misattributed report explained at https://lkml.kernel.org/r/20190924140241.be77u2jne3melzte@pathway.suse.cz .
>> Petr and Sergey, how is the progress of making printk() asynchronous? When can we expect that work to be merged?
> 
> I'd say that lockless logbuf probably will land sometime around 5.8+.
> Async printk() - unknown.

I see. Thank you. I've just made a patch for

  A solution would be to store all these metadata (timestamp, caller
  info) already into the per-CPU buffers. I think that it would be
  doable.

part (shown below). Should I propose it? Or, should I just wait for lockless logbuf ?

diff --git a/kernel/printk/internal.h b/kernel/printk/internal.h
index b2b0f526f249..3e7b302d41e8 100644
--- a/kernel/printk/internal.h
+++ b/kernel/printk/internal.h
@@ -52,6 +52,22 @@ bool printk_percpu_data_ready(void);
 
 void defer_console_output(void);
 
+struct printk_msg {
+	u64 ts_nsec;	/* timestamp in nanoseconds */
+	u32 caller_id;	/* thread id or processor id */
+	u16 len;	/* length of entire record */
+	u16 text_len;	/* length of text buffer */
+	u16 dict_len;	/* length of dictionary buffer */
+	u8 facility;	/* syslog facility */
+	u8 flags;	/* internal record flags */
+	int level;	/* syslog level (maybe LOGLEVEL_DEFAULT upon init) */
+};
+
+void printk_msg_init(struct printk_msg *msg, const u8 facility, const int level,
+		     const u8 flags, const u16 dict_len, const u16 text_len);
+int printk_msg_store(struct printk_msg *msg, const char *text, const char *dict,
+		     const bool logbuf_locked);
+
 #else
 
 __printf(1, 0) int vprintk_func(const char *fmt, va_list args) { return 0; }
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 9a9b6156270b..6be45a59d3aa 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -613,12 +613,16 @@ static u32 truncate_msg(u16 *text_len, u16 *trunc_msg_len,
 }
 
 /* insert record into the buffer, discard old ones, update heads */
-static int log_store(u32 caller_id, int facility, int level,
-		     enum log_flags flags, u64 ts_nsec,
-		     const char *dict, u16 dict_len,
-		     const char *text, u16 text_len)
-{
-	struct printk_log *msg;
+static int log_store(const struct printk_msg *msg, const char *text, const char *dict)
+{
+	const u32 caller_id = msg->caller_id;
+	const int facility = msg->facility;
+	const int level = msg->level;
+	const enum log_flags flags = msg->flags;
+	const u64 ts_nsec = msg->ts_nsec;
+	u16 dict_len = msg->dict_len;
+	u16 text_len = msg->text_len;
+	struct printk_log *log;
 	u32 size, pad_len;
 	u16 trunc_msg_len = 0;
 
@@ -645,33 +649,30 @@ static int log_store(u32 caller_id, int facility, int level,
 	}
 
 	/* fill message */
-	msg = (struct printk_log *)(log_buf + log_next_idx);
-	memcpy(log_text(msg), text, text_len);
-	msg->text_len = text_len;
+	log = (struct printk_log *)(log_buf + log_next_idx);
+	memcpy(log_text(log), text, text_len);
+	log->text_len = text_len;
 	if (trunc_msg_len) {
-		memcpy(log_text(msg) + text_len, trunc_msg, trunc_msg_len);
-		msg->text_len += trunc_msg_len;
-	}
-	memcpy(log_dict(msg), dict, dict_len);
-	msg->dict_len = dict_len;
-	msg->facility = facility;
-	msg->level = level & 7;
-	msg->flags = flags & 0x1f;
-	if (ts_nsec > 0)
-		msg->ts_nsec = ts_nsec;
-	else
-		msg->ts_nsec = local_clock();
+		memcpy(log_text(log) + text_len, trunc_msg, trunc_msg_len);
+		log->text_len += trunc_msg_len;
+	}
+	memcpy(log_dict(log), dict, dict_len);
+	log->dict_len = dict_len;
+	log->facility = facility;
+	log->level = level & 7;
+	log->flags = flags & 0x1f;
+	log->ts_nsec = ts_nsec;
 #ifdef CONFIG_PRINTK_CALLER
-	msg->caller_id = caller_id;
+	log->caller_id = caller_id;
 #endif
-	memset(log_dict(msg) + dict_len, 0, pad_len);
-	msg->len = size;
+	memset(log_dict(log) + dict_len, 0, pad_len);
+	log->len = size;
 
 	/* insert message */
-	log_next_idx += msg->len;
+	log_next_idx += log->len;
 	log_next_seq++;
 
-	return msg->text_len;
+	return log->text_len;
 }
 
 int dmesg_restrict = IS_ENABLED(CONFIG_SECURITY_DMESG_RESTRICT);
@@ -1837,109 +1838,111 @@ static inline u32 printk_caller_id(void)
 		0x80000000 + raw_smp_processor_id();
 }
 
+void printk_msg_init(struct printk_msg *msg, const u8 facility, const int level,
+		     const u8 flags, const u16 dict_len, const u16 text_len)
+{
+	memset(msg, 0, sizeof(*msg));
+#ifdef CONFIG_PRINTK_CALLER
+	msg->caller_id = printk_caller_id();
+#endif
+	msg->facility = facility;
+	msg->level = level;
+	msg->flags = flags;
+	msg->ts_nsec = local_clock();
+	msg->dict_len = dict_len;
+	msg->text_len = text_len;
+}
+
 /*
  * Continuation lines are buffered, and not committed to the record buffer
  * until the line is complete, or a race forces it. The line fragments
  * though, are printed immediately to the consoles to ensure everything has
  * reached the console in case of a kernel crash.
+ *
+ * .text_len == 0 means unused buffer.
+ * .caller_id is printk_caller_id() of first print.
+ * .ts_nsec is time of first print.
+ * .level is log level of first message.
+ * .facility is log facility of first message.
+ * .flags is prefix, newline flags
  */
-static struct cont {
-	char buf[LOG_LINE_MAX];
-	size_t len;			/* length == 0 means unused buffer */
-	u32 caller_id;			/* printk_caller_id() of first print */
-	u64 ts_nsec;			/* time of first print */
-	u8 level;			/* log level of first message */
-	u8 facility;			/* log facility of first message */
-	enum log_flags flags;		/* prefix, newline flags */
-} cont;
+static struct printk_msg cont_msg;
+static char cont_buf[LOG_LINE_MAX];
 
 static void cont_flush(void)
 {
-	if (cont.len == 0)
+	if (cont_msg.text_len == 0)
 		return;
-
-	log_store(cont.caller_id, cont.facility, cont.level, cont.flags,
-		  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
-	cont.len = 0;
+	log_store(&cont_msg, cont_buf, NULL);
+	cont_msg.text_len = 0;
 }
 
-static bool cont_add(u32 caller_id, int facility, int level,
-		     enum log_flags flags, const char *text, size_t len)
+static bool cont_add(const struct printk_msg *msg, const char *text)
 {
 	/* If the line gets too long, split it up in separate records. */
-	if (cont.len + len > sizeof(cont.buf)) {
+	if (cont_msg.text_len + msg->text_len > sizeof(cont_buf)) {
 		cont_flush();
 		return false;
 	}
 
-	if (!cont.len) {
-		cont.facility = facility;
-		cont.level = level;
-		cont.caller_id = caller_id;
-		cont.ts_nsec = local_clock();
-		cont.flags = flags;
-	}
+	if (!cont_msg.text_len)
+		printk_msg_init(&cont_msg, msg->facility, msg->level,
+				msg->flags, 0, 0);
 
-	memcpy(cont.buf + cont.len, text, len);
-	cont.len += len;
+	memcpy(cont_buf + cont_msg.text_len, text, msg->text_len);
+	cont_msg.text_len += msg->text_len;
 
 	// The original flags come from the first line,
 	// but later continuations can add a newline.
-	if (flags & LOG_NEWLINE) {
-		cont.flags |= LOG_NEWLINE;
+	if (msg->flags & LOG_NEWLINE) {
+		cont_msg.flags |= LOG_NEWLINE;
 		cont_flush();
 	}
 
 	return true;
 }
 
-static size_t log_output(int facility, int level, enum log_flags lflags, const char *dict, size_t dictlen, char *text, size_t text_len)
-{
-	const u32 caller_id = printk_caller_id();
 
+static size_t log_output(struct printk_msg *msg, const char *text,
+			 const char *dict)
+{
 	/*
 	 * If an earlier line was buffered, and we're a continuation
 	 * write from the same context, try to add it to the buffer.
 	 */
-	if (cont.len) {
-		if (cont.caller_id == caller_id && (lflags & LOG_CONT)) {
-			if (cont_add(caller_id, facility, level, lflags, text, text_len))
-				return text_len;
+	if (cont_msg.text_len) {
+		if (cont_msg.caller_id == msg->caller_id &&
+		    (msg->flags & LOG_CONT)) {
+			if (cont_add(msg, text))
+				return msg->text_len;
 		}
 		/* Otherwise, make sure it's flushed */
 		cont_flush();
 	}
 
 	/* Skip empty continuation lines that couldn't be added - they just flush */
-	if (!text_len && (lflags & LOG_CONT))
+	if (!msg->text_len && (msg->flags & LOG_CONT))
 		return 0;
 
 	/* If it doesn't end in a newline, try to buffer the current line */
-	if (!(lflags & LOG_NEWLINE)) {
-		if (cont_add(caller_id, facility, level, lflags, text, text_len))
-			return text_len;
+	if (!(msg->flags & LOG_NEWLINE)) {
+		if (cont_add(msg, text))
+			return msg->text_len;
 	}
 
 	/* Store it in the record log */
-	return log_store(caller_id, facility, level, lflags, 0,
-			 dict, dictlen, text, text_len);
+	return log_store(msg, text, dict);
 }
 
-/* Must be called under logbuf_lock. */
-int vprintk_store(int facility, int level,
-		  const char *dict, size_t dictlen,
-		  const char *fmt, va_list args)
+int printk_msg_store(struct printk_msg *msg, const char *text, const char *dict,
+		     const bool logbuf_locked)
 {
-	static char textbuf[LOG_LINE_MAX];
-	char *text = textbuf;
-	size_t text_len;
-	enum log_flags lflags = 0;
-
-	/*
-	 * The printf needs to come first; we need the syslog
-	 * prefix which might be passed-in as a parameter.
-	 */
-	text_len = vscnprintf(text, sizeof(textbuf), fmt, args);
+	unsigned long flags;
+	size_t ret;
+	const int facility = msg->facility;
+	int level = msg->level;
+	size_t text_len = msg->text_len;
+	enum log_flags lflags = msg->flags;
 
 	/* mark and strip a trailing newline */
 	if (text_len && text[text_len-1] == '\n') {
@@ -1972,8 +1975,32 @@ int vprintk_store(int facility, int level,
 	if (dict)
 		lflags |= LOG_NEWLINE;
 
-	return log_output(facility, level, lflags,
-			  dict, dictlen, text, text_len);
+	msg->flags = lflags;
+	msg->text_len = text_len;
+	msg->level = level;
+	if (!logbuf_locked)
+		logbuf_lock_irqsave(flags);
+	ret = log_output(msg, text, dict);
+	if (!logbuf_locked)
+		logbuf_unlock_irqrestore(flags);
+	return ret;
+}
+
+/* Must be called under logbuf_lock. */
+int vprintk_store(int facility, int level,
+		  const char *dict, size_t dictlen,
+		  const char *fmt, va_list args)
+{
+	static struct printk_msg msg;
+	static char textbuf[LOG_LINE_MAX];
+	/*
+	 * The printf needs to come first; we need the syslog
+	 * prefix which might be passed-in as a parameter.
+	 */
+	size_t text_len = vscnprintf(textbuf, sizeof(textbuf), fmt, args);
+
+	printk_msg_init(&msg, facility, level, 0, dictlen, text_len);
+	return printk_msg_store(&msg, textbuf, dict, true);
 }
 
 asmlinkage int vprintk_emit(int facility, int level,
diff --git a/kernel/printk/printk_safe.c b/kernel/printk/printk_safe.c
index d9a659a686f3..009a9c6892bc 100644
--- a/kernel/printk/printk_safe.c
+++ b/kernel/printk/printk_safe.c
@@ -67,6 +67,7 @@ static void queue_flush_work(struct printk_safe_seq_buf *s)
 static __printf(2, 0) int printk_safe_log_store(struct printk_safe_seq_buf *s,
 						const char *fmt, va_list args)
 {
+	struct printk_msg *msg;
 	int add;
 	size_t len;
 	va_list ap;
@@ -89,10 +90,13 @@ static __printf(2, 0) int printk_safe_log_store(struct printk_safe_seq_buf *s,
 		smp_rmb();
 
 	va_copy(ap, args);
-	add = vscnprintf(s->buffer + len, sizeof(s->buffer) - len, fmt, ap);
+	add = vscnprintf(s->buffer + len + sizeof(*msg), sizeof(s->buffer) - len - sizeof(*msg), fmt, ap);
 	va_end(ap);
 	if (!add)
 		return 0;
+	msg = (struct printk_msg *) (s->buffer + len);
+	printk_msg_init(msg, 0, LOGLEVEL_DEFAULT, 0, 0, add);
+	add += sizeof(*msg);
 
 	/*
 	 * Do it once again if the buffer has been flushed in the meantime.
@@ -117,51 +121,21 @@ static inline void printk_safe_flush_line(const char *text, int len)
 	printk_deferred("%.*s", len, text);
 }
 
-/* printk part of the temporary buffer line by line */
+/* printk part of the temporary buffer record by record */
 static int printk_safe_flush_buffer(const char *start, size_t len)
 {
-	const char *c, *end;
-	bool header;
+	const char *c = start;
+	const char *end = start + len;
+	struct printk_msg *msg;
 
-	c = start;
-	end = start + len;
-	header = true;
-
-	/* Print line by line. */
 	while (c < end) {
-		if (*c == '\n') {
-			printk_safe_flush_line(start, c - start + 1);
-			start = ++c;
-			header = true;
-			continue;
-		}
-
-		/* Handle continuous lines or missing new line. */
-		if ((c + 1 < end) && printk_get_level(c)) {
-			if (header) {
-				c = printk_skip_level(c);
-				continue;
-			}
-
-			printk_safe_flush_line(start, c - start);
-			start = c++;
-			header = true;
-			continue;
-		}
-
-		header = false;
-		c++;
+		msg = (struct printk_msg *) c;
+		/* printk_msg_store() updates msg->text_len. */
+		len = READ_ONCE(msg->text_len);
+		printk_msg_store(msg, c + sizeof(*msg), NULL, false);
+		c += sizeof(*msg) + len;
 	}
-
-	/* Check if there was a partial line. Ignore pure header. */
-	if (start < end && !header) {
-		static const char newline[] = KERN_CONT "\n";
-
-		printk_safe_flush_line(start, end - start);
-		printk_safe_flush_line(newline, strlen(newline));
-	}
-
-	return len;
+	return end - start;
 }
 
 static void report_message_lost(struct printk_safe_seq_buf *s)
@@ -231,6 +205,7 @@ static void __printk_safe_flush(struct irq_work *work)
 out:
 	report_message_lost(s);
 	raw_spin_unlock_irqrestore(&read_lock, flags);
+	defer_console_output();
 }
 
 /**
