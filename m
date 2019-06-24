Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02AAE51987
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732433AbfFXR1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:27:55 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39636 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfFXR1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:27:55 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hfSkS-0002LX-Cg; Mon, 24 Jun 2019 19:27:20 +0200
Date:   Mon, 24 Jun 2019 19:27:18 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Dmitry Vyukov <dvyukov@google.com>
cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzbot+c4521ac872a4ccc3afec@syzkaller.appspotmail.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        amritha.nambiar@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ido Schimmel <idosch@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tyhicks@canonical.com, wanghai26@huawei.com, yuehaibing@huawei.com
Subject: Re: WARNING: ODEBUG bug in netdev_freemem (2)
In-Reply-To: <alpine.DEB.2.21.1906241433020.32342@nanos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.21.1906241920540.32342@nanos.tec.linutronix.de>
References: <000000000000d6a8ba058c0df076@google.com> <alpine.DEB.2.21.1906241130100.32342@nanos.tec.linutronix.de> <CACT4Y+Y_TadXGE_CVFa4fKqrbpAD4i5WGem9StgoyP_YAVraXw@mail.gmail.com> <da83da44-0088-3056-6bba-d028b6cbb218@gmail.com>
 <CACT4Y+bk1h+CFVdbbKau490Wjis8zt_ia8gVctGZ+bs=7qPk=Q@mail.gmail.com> <alpine.DEB.2.21.1906241433020.32342@nanos.tec.linutronix.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jun 2019, Thomas Gleixner wrote:
> On Mon, 24 Jun 2019, Dmitry Vyukov wrote:
> > On Mon, Jun 24, 2019 at 2:08 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > >>> ------------[ cut here ]------------
> > > >>> ODEBUG: free active (active state 0) object type: timer_list hint:
> > > >>> delayed_work_timer_fn+0x0/0x90 arch/x86/include/asm/paravirt.h:767
> > > >>
> > > >> One of the cleaned up devices has left an active timer which belongs to a
> > > >> delayed work. That's all I can decode out of that splat. :(
> > > >
> > > > Hi Thomas,
> > > >
> > > > If ODEBUG would memorize full stack traces for object allocation
> > > > (using lib/stackdepot.c), it would make this splat actionable, right?
> > > > I've fixed https://bugzilla.kernel.org/show_bug.cgi?id=203969 for this.
> > > >
> > >
> > > Not sure this would help in this case as some netdev are allocated through a generic helper.
> > >
> > > The driver specific portion might not show up in the stack trace.
> > >
> > > It would be nice here to get the work queue function pointer,
> > > so that it gives us a clue which driver needs a fix.
> 
> Hrm. Let me think about a way to achieve that after I handled that
> regression which is on my desk.

Here is a quick and dirty hack which solves the issue at least for all run
time initialized delayed work objects. Here is the output of a test I
whipped up for this:

 OBJ: Init delayed work, arm timer
 OBJ: Leak timer
 ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x20 chint: foo_fun+0x0/0x17

chint is the debug object hint of the compound object, i.e. the work
function 'foo_fun'.

Yes, naming sucks and there is still the option to use the existing
debug_obj::astate mechanics, but I was not able to wrap my head around all
the nasty corner cases which the workqueue code provides quickly. Needs
more thought.

Anyway, this should definitely help to diagnose the issue at hand.

Thanks,

	tglx

8<--------------------
 include/linux/debugobjects.h |   10 ++++++++++
 include/linux/workqueue.h    |   26 ++++++++++++++++----------
 kernel/workqueue.c           |    9 ++++++++-
 lib/debugobjects.c           |   43 +++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 75 insertions(+), 13 deletions(-)

--- a/include/linux/debugobjects.h
+++ b/include/linux/debugobjects.h
@@ -24,6 +24,9 @@ struct debug_obj_descr;
  * @astate:	current active state
  * @object:	pointer to the real object
  * @descr:	pointer to an object type specific debug description structure
+ * @comp_addr:	pointer to a compound object which is glued with @object
+ * @comp_descr:	pointer to a compound object type specific debug description
+ *		structure
  */
 struct debug_obj {
 	struct hlist_node	node;
@@ -31,6 +34,8 @@ struct debug_obj {
 	unsigned int		astate;
 	void			*object;
 	struct debug_obj_descr	*descr;
+	void			*comp_addr;
+	struct debug_obj_descr	*comp_descr;
 };
 
 /**
@@ -82,6 +87,9 @@ extern void
 debug_object_active_state(void *addr, struct debug_obj_descr *descr,
 			  unsigned int expect, unsigned int next);
 
+extern void debug_object_set_compound(void *addr, void *comp_addr,
+				      struct debug_obj_descr *comp_descr);
+
 extern void debug_objects_early_init(void);
 extern void debug_objects_mem_init(void);
 #else
@@ -99,6 +107,8 @@ static inline void
 debug_object_free      (void *addr, struct debug_obj_descr *descr) { }
 static inline void
 debug_object_assert_init(void *addr, struct debug_obj_descr *descr) { }
+static inline void
+debug_object_set_compound(void *addr, void *ca, struct debug_obj_descr *cd) { }
 
 static inline void debug_objects_early_init(void) { }
 static inline void debug_objects_mem_init(void) { }
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -204,7 +204,7 @@ struct execute_work {
 	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f, TIMER_DEFERRABLE)
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
-extern void __init_work(struct work_struct *work, int onstack);
+extern void __init_work(struct work_struct *work, int onstack, bool delayed);
 extern void destroy_work_on_stack(struct work_struct *work);
 extern void destroy_delayed_work_on_stack(struct delayed_work *work);
 static inline unsigned int work_static(struct work_struct *work)
@@ -212,7 +212,7 @@ static inline unsigned int work_static(s
 	return *work_data_bits(work) & WORK_STRUCT_STATIC;
 }
 #else
-static inline void __init_work(struct work_struct *work, int onstack) { }
+static inline void __init_work(struct work_struct *work, int onstack, bool delayed) { }
 static inline void destroy_work_on_stack(struct work_struct *work) { }
 static inline void destroy_delayed_work_on_stack(struct delayed_work *work) { }
 static inline unsigned int work_static(struct work_struct *work) { return 0; }
@@ -226,20 +226,20 @@ static inline unsigned int work_static(s
  * to generate better code.
  */
 #ifdef CONFIG_LOCKDEP
-#define __INIT_WORK(_work, _func, _onstack)				\
+#define __INIT_WORK(_work, _func, _onstack, _delayed)			\
 	do {								\
 		static struct lock_class_key __key;			\
 									\
-		__init_work((_work), _onstack);				\
+		__init_work((_work), _onstack, _delayed);		\
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
 		lockdep_init_map(&(_work)->lockdep_map, "(work_completion)"#_work, &__key, 0); \
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		(_work)->func = (_func);				\
 	} while (0)
 #else
-#define __INIT_WORK(_work, _func, _onstack)				\
+#define __INIT_WORK(_work, _func, _onstack, _delayed)			\
 	do {								\
-		__init_work((_work), _onstack);				\
+		__init_work((_work), _onstack, _delayed);		\
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		(_work)->func = (_func);				\
@@ -247,25 +247,31 @@ static inline unsigned int work_static(s
 #endif
 
 #define INIT_WORK(_work, _func)						\
-	__INIT_WORK((_work), (_func), 0)
+	__INIT_WORK((_work), (_func), 0, 0)
 
 #define INIT_WORK_ONSTACK(_work, _func)					\
-	__INIT_WORK((_work), (_func), 1)
+	__INIT_WORK((_work), (_func), 1, 0)
+
+#define __INIT_DWORK(_work, _func)					\
+	__INIT_WORK((_work), (_func), 0, 1)
+
+#define __INIT_DWORK_ONSTACK(_work, _func)				\
+	__INIT_WORK((_work), (_func), 1, 1)
 
 #define __INIT_DELAYED_WORK(_work, _func, _tflags)			\
 	do {								\
-		INIT_WORK(&(_work)->work, (_func));			\
 		__init_timer(&(_work)->timer,				\
 			     delayed_work_timer_fn,			\
 			     (_tflags) | TIMER_IRQSAFE);		\
+		__INIT_DWORK(&(_work)->work, (_func));			\
 	} while (0)
 
 #define __INIT_DELAYED_WORK_ONSTACK(_work, _func, _tflags)		\
 	do {								\
-		INIT_WORK_ONSTACK(&(_work)->work, (_func));		\
 		__init_timer_on_stack(&(_work)->timer,			\
 				      delayed_work_timer_fn,		\
 				      (_tflags) | TIMER_IRQSAFE);	\
+		__INIT_DWORK_ONSTACK(&(_work)->work, (_func));		\
 	} while (0)
 
 #define INIT_DELAYED_WORK(_work, _func)					\
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -499,12 +499,19 @@ static inline void debug_work_deactivate
 	debug_object_deactivate(work, &work_debug_descr);
 }
 
-void __init_work(struct work_struct *work, int onstack)
+void __init_work(struct work_struct *work, int onstack, bool delayed)
 {
 	if (onstack)
 		debug_object_init_on_stack(work, &work_debug_descr);
 	else
 		debug_object_init(work, &work_debug_descr);
+
+	if (delayed) {
+		struct delayed_work *dwork = to_delayed_work(work);
+
+		debug_object_set_compound(&dwork->timer, work,
+					  &work_debug_descr);
+	}
 }
 EXPORT_SYMBOL_GPL(__init_work);
 
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -179,6 +179,8 @@ alloc_object(void *addr, struct debug_bu
 		obj->descr  = descr;
 		obj->state  = ODEBUG_STATE_NONE;
 		obj->astate = 0;
+		obj->comp_addr = NULL;
+		obj->comp_descr = NULL;
 		hlist_del(&obj->node);
 
 		hlist_add_head(&obj->node, &b->list);
@@ -321,11 +323,17 @@ static void debug_print_object(struct de
 	if (limit < 5 && descr != descr_test) {
 		void *hint = descr->debug_hint ?
 			descr->debug_hint(obj->object) : NULL;
+		void *chint = NULL;
+
+		/* Get a hint about a compound object */
+		if (obj->comp_descr && obj->comp_descr->debug_hint)
+			chint = obj->comp_descr->debug_hint(obj->comp_addr);
+
 		limit++;
 		WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) "
-				 "object type: %s hint: %pS\n",
+				 "object type: %s hint: %pS chint: %pS\n",
 			msg, obj_states[obj->state], obj->astate,
-			descr->name, hint);
+		     descr->name, hint, chint);
 	}
 	debug_objects_warnings++;
 }
@@ -448,6 +456,37 @@ void debug_object_init_on_stack(void *ad
 EXPORT_SYMBOL_GPL(debug_object_init_on_stack);
 
 /**
+ * debug_object_set_compound - Set a pointer to a compund object
+ * @addr:	address of the object
+ * @comp_addr:	pointer to the compound object related to @addr
+ * @comp_descr:	pointer to an object specific debug description structure for
+ *		@comp_addr
+ *
+ * Useful for delayed work and similar constructs where the
+ * debug_obj::astate tracking would be complex to achieve.
+ */
+void debug_object_set_compound(void *addr, void *comp_addr,
+			       struct debug_obj_descr *comp_descr)
+{
+	struct debug_bucket *db;
+	struct debug_obj *obj;
+	unsigned long flags;
+
+	if (!debug_objects_enabled)
+		return;
+
+	db = get_bucket((unsigned long) addr);
+
+	raw_spin_lock_irqsave(&db->lock, flags);
+	obj = lookup_object(addr, db);
+	if (obj) {
+		obj->comp_addr = comp_addr;
+		obj->comp_descr = comp_descr;
+	}
+	raw_spin_unlock_irqrestore(&db->lock, flags);
+}
+
+/**
  * debug_object_activate - debug checks when an object is activated
  * @addr:	address of the object
  * @descr:	pointer to an object specific debug description structure
